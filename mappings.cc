#include <cctype>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <set>
#include <string>
#include <sstream>
#include <vector>

std::set<std::string> make_all_key_names()
{
    static const std::string NO_CONTROL = "\"$%&*/`{|}~";
    static const std::set<std::string> KEY_NAMES{
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

    enum Mods {
        SHIFT   = 1,
        CONTROL = 2,
        META    = 4
    };

    std::set<std::string> result;
    for (int modifiers = 0; modifiers < 8; modifiers++) {
        for (auto const& name : KEY_NAMES) {
            if (name.size() == 1) {
                // ASCII chars
                if (modifiers & SHIFT)
                    continue; // Shifted version has own key name.
                if (isupper(name[0] && (modifiers & CONTROL)))
                    continue; // C-x not different from C-X
                if (NO_CONTROL.find(name[0]) != std::string::npos && (modifiers & CONTROL))
                    continue;
            }

            if (name == "Escape" && modifiers)
                continue;

            std::string keyname;
            if (modifiers & SHIFT)
                keyname += "S-";
            if (modifiers & CONTROL)
                keyname += "C-";
            if (modifiers & META)
                keyname += "M-";
            keyname += name;
            result.insert(std::move(keyname));
        }
    }
    return result;
}

static const std::set<std::string> ALL_KEY_NAMES = make_all_key_names();

struct InputRecord
{
    std::string move_mode;
    std::string extend_mode;
    std::string next_mode;
    std::vector<std::string> move_keys;
    std::vector<std::string> extend_keys;
    std::vector<std::string> actions;

    bool is_header() const
    {
        return move_keys.empty() && extend_keys.empty();
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

private:
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

void clear_mode(std::string const& mode, std::string const& next_mode)
{
    for (auto const& keyname : ALL_KEY_NAMES) {
        std::cout << "bind-key -Tcopy-mode-kakoune-" << mode << " "
            << tmux_quote(keyname) << " switch-client -Tcopy-mode-kakoune-"
            << next_mode << std::endl;
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

        InputRecord record = InputRecord::parse(line);
        if (record.is_header()) {
            header = record;
            clear_table(header);
        } else {
            record.merge_header(header);
            make_mappings(record);
        }
    }

    return 0;
}
