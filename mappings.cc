#include <cctype>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <set>
#include <string>
#include <sstream>
#include <vector>

std::string tmux_quote(std::string const& s)
{
    std::string result = "\'";
    for (char ch : s) {
        if (ch == '\'')
            result += "'\"'\"'";
        else
            result += ch;
    }
    result += "'";
    return result;
}

std::string escape_double_quotes(std::string const& s)
{
    std::string result = "";
    for (char ch : s) {
        switch (ch) {
        case '"':  result += "\\\""; break;
        default:   result += ch;     break;
        }
    }
    return result;
}

std::string table_name(std::string const& s)
{
    if (s == "normal")
        return "copy-mode-vi";
    return "copy-mode-kakoune-" + s;
}

struct InputRecord
{
    std::string move_mode;
    std::string extend_mode;
    std::string next_mode;
    std::string prompt{"(prompt)"};
    std::vector<std::string> move_keys;
    std::vector<std::string> extend_keys;
    std::vector<std::string> actions;

    bool is_header() const
    {
        return move_keys.empty() && extend_keys.empty();
    }

    bool wants_prompt() const
    {
        for (auto const& action : actions)
            if (action.find("%%%") != std::string::npos)
                return true;
        return false;
    }

    void merge_header(InputRecord const& header)
    {
        if (next_mode.empty())
            next_mode = header.next_mode;
        if (extend_mode.empty())
            extend_mode = header.extend_mode;
        if (extend_mode.empty())
            extend_mode = move_mode;
    }

    std::string format_actions(std::string const& indent, bool skip_begin_selection) const
    {
        std::string result;
        for (auto const& action : actions) {
            if (skip_begin_selection && action == "begin-selection")
                continue;
            result += indent + "send-keys -X " + action + "\n";
        }
        if (not next_mode.empty())
            result += indent + "switch-client -T" + table_name(next_mode) + "\n";
        return result;
    }

    static InputRecord parse(std::string const& line)
    {
        InputRecord result;
        std::istringstream in(line);

        in >> result.move_mode;

        std::string keys;
        in >> keys;
        result.move_keys = tokenize_keys(keys);

        in >> keys;
        result.extend_keys = tokenize_keys(keys);

        std::string action;
        while (read_word(in,action)) {
            if (action.rfind("->", 0) == 0)
                result.next_mode = action.substr(2);
            else if (action.rfind("extend-mode=", 0) == 0)
                result.extend_mode = action.substr(std::string("extend-mode=").size());
            else if (action.rfind("prompt=", 0) == 0)
                result.prompt = action.substr(std::string("prompt=").size());
            else
                result.actions.push_back(action);
        }

        return result;
    }

private:
    static bool read_word(std::istream& in, std::string& word)
    {
        word.clear();
        in >> std::ws;

        bool have_word = false;
        bool in_quotes = false;
        char ch;
        while (in.get(ch)) {
            if (ch == '\'' and in_quotes and in.peek() == '\'') {
                have_word = true;
                in.get(ch);
                word += '\'';
                continue;
            }
            if (ch == '\'' and in_quotes) {
                have_word = true;
                in_quotes = false;
                continue;
            }
            if (ch == '\'' and not in_quotes) {
                have_word = true;
                in_quotes = true;
                continue;
            }
            if (isspace(ch) and not in_quotes)
                break;
            have_word = true;
            word += ch;
        }

        return have_word;
    }

    static std::vector<std::string> tokenize_keys(std::string const& keys)
    {
        if (keys == "--")
            return {};
        if (keys == ",")
            return {","};
        std::vector<std::string> result;
        std::istringstream in(keys);
        std::string token;
        while (std::getline(in, token, ','))
            result.emplace_back(std::move(token));
        return result;
    }
};

void make_mapping(InputRecord const& record, std::string const& mode, std::string const& key, bool skip_begin_selection)
{
    std::cout << "bind-key -T" << table_name(mode) << " " << tmux_quote(key) << " {\n";
    if (record.wants_prompt()) {
        std::string prompt = escape_double_quotes(record.prompt);
        if (skip_begin_selection) {
            auto pos = prompt.find("select");
            if (pos != std::string::npos) {
                prompt.replace(pos, pos+5, "extend");
            }
        }
        std::cout << "    command-prompt -1 -p \"" << prompt << "\" {\n";
        std::cout << record.format_actions("        ", skip_begin_selection);
        std::cout << "    }\n";
    } else {
        std::cout << record.format_actions("    ", skip_begin_selection);
    }
    std::cout << "}\n";
}

void make_mappings(InputRecord const& record)
{
    for (auto const& key : record.move_keys)
        make_mapping(record, record.move_mode, key, false);
    for (auto const& key : record.extend_keys)
        make_mapping(record, record.extend_mode, key, true);
}

int main(int argc, char *argv[])
{
    std::string line;
    InputRecord header;

    std::getline(std::cin, line);
    std::getline(std::cin, line);
    while (std::getline(std::cin, line)) {
        if (line.empty())
            continue;
        if (line.rfind("<", 0) == 0)
            continue;

        InputRecord record = InputRecord::parse(line);
        if (record.is_header()) {
            header = record;
        } else {
            record.merge_header(header);
            make_mappings(record);
        }
    }

    return 0;
}
