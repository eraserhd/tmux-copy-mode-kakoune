#include <cctype>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <set>
#include <string>
#include <sstream>
#include <vector>

const std::set<std::string> KEY_NAMES{
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11",
    "F12", "IC", "Insert", "DC", "Delete", "Home", "End", "NPage",
    "PageDown", "PgDn", "PPage", "PageUp", "PgUp", "Tab", "BTab", "Space",
    "BSpace", "Enter", "Escape", "Up", "Down", "Left", "Right", "KP/",
    "KP*", "KP-", "KP7", "KP8", "KP9", "KP+", "KP4", "KP5", "KP6", "KP1",
    "KP2", "KP3", "KPEnter", "KP0", "KP.",
    "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", "-", ".", "/",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    ":", ";", "<", "=", ">", "?", "@",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "[", "\\", "]", "^", "_", "`",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "{", "|", "}", "~"
};

struct InputRecord
{
    std::string move_mode;
    std::string extend_mode;
    std::string next_mode;
    std::vector<std::string> move_keys;
    std::vector<std::string> extend_keys;
    std::vector<std::string> actions;
};

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

std::vector<std::string> tokenize_keys(std::string const& keys)
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

InputRecord parse_input_record(std::string const& line)
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
    while (in >> action) {
        if (action.rfind("->", 0) == 0)
            result.next_mode = action.substr(2);
        else if (action.rfind("extend-mode=", 0) == 0)
            result.extend_mode = action.substr(std::string("extend-mode=").size());
        else
            result.actions.push_back(action);
    }

    return result;
}

void clear_mode(std::string const& mode, std::string const& next_mode)
{
    static const std::string NO_CONTROL = "\"$%&*/`{|}~";
    for (int modifiers = 0; modifiers < 8; modifiers++) {
        for (auto const& name : KEY_NAMES) {
            if (name.size() == 1) {
                // ASCII chars
                if (modifiers & 1)
                    continue; // Shifted version has own key name.
                if (isupper(name[0] && (modifiers & 2)))
                    continue; // C-x not different from C-X
                if (NO_CONTROL.find(name[0]) != std::string::npos && (modifiers & 2))
                    continue;
            }

            if (name == "Escape" && modifiers)
                continue;

            std::string keyname;
            if (modifiers & 1)
                keyname += "S-";
            if (modifiers & 2)
                keyname += "C-";
            if (modifiers & 4)
                keyname += "M-";
            keyname += name;
            std::cout << "bind-key -Tcopy-mode-kakoune-" << mode << " "
                << tmux_quote(keyname) << " switch-client -Tcopy-mode-kakoune-"
                << next_mode << std::endl;
        }
    }
}

void clear_table(InputRecord const& header)
{
    if (header.next_mode == "" || header.next_mode == "none")
        return;
    clear_mode(header.move_mode, header.next_mode);
    if (header.extend_mode == "" || header.extend_mode == header.move_mode)
        return;
    clear_mode(header.extend_mode, header.next_mode);
}

void make_mapping(InputRecord const& record, std::string const& mode, std::string const& key, bool skip_begin_selection)
{
    std::cout << "bind-key -Tcopy-mode-kakoune-" << mode << " " << tmux_quote(key) << " '\\\n";

    for (auto const& action : record.actions) {
        if (skip_begin_selection && action == "begin-selection")
            continue;
        std::cout << "    send-keys -X " << action << " ;\\\n";
    }

    if (record.next_mode != "none")
        std::cout << "    switch-client -Tcopy-mode-kakoune-" << record.next_mode << " ;\\\n";

    std::cout << "'\n";
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

        InputRecord record = parse_input_record(line);
        if (record.move_keys.empty() && record.extend_keys.empty()) {
            header = record;
            clear_table(header);
        } else {
            if (record.next_mode.empty())
                record.next_mode = header.next_mode;
            if (record.extend_mode.empty())
                record.extend_mode = header.extend_mode;
            if (record.extend_mode.empty())
                record.extend_mode = record.move_mode;
            make_mappings(record);
        }
    }

    return 0;
}
