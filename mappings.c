#define _XOPEN_SOURCE 600

#include <assert.h>
#include <ctype.h>
#include <malloc.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* KEY_NAMES[] = {
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

typedef struct input_record_tag {
        char *move_mode;
        char *extend_mode;
        char *next_mode;
        char *move_keys[64];
        char *extend_keys[64];
        char *actions[64];
} input_record_t;

char *tmux_quote(const char* s)
{
        char *result = (char*)malloc(3 + strlen(s)*5);
        char *p = result;
        *p++ = '\'';
        for (; *s; s++) {
                switch (*s) {
                case '\'':
                        *p++ = '\'';
                        *p++ = '"';
                        *p++ = '\'';
                        *p++ = '"';
                        *p++ = '\'';
                        break;
                default:
                        *p++ = *s;
                        break;
                }
        }
        *p++ = '\'';
        *p++ = '\0';
        return result;
}

void tokenize_keys(char *keys, char *output[64])
{
        int i = 0;
        if (!strcmp(keys, ","))
                output[i++] = keys;
        else if (!strcmp(keys, "--"))
                ;
        else {
                char *saveptr;
                char *key = strtok_r(keys, ",", &saveptr);
                while (key) {
                        output[i++] = key;
                        key = strtok_r(NULL, ",", &saveptr);
                        assert(i < 63);
                }
        }
}

input_record_t parse_input_record(char *line)
{
        struct input_record_tag result = {0};

        char *saveptr;
        result.move_mode = strtok_r(line, " \t\v", &saveptr);
        assert(result.move_mode);

        char *move_keys = strtok_r(NULL, " \t\v", &saveptr);
        assert(move_keys);
        tokenize_keys(move_keys, result.move_keys);

        char *extend_keys = strtok_r(NULL, " \t\v", &saveptr);
        assert(extend_keys);
        tokenize_keys(extend_keys, result.extend_keys);

        int i = 0;
        char *action;
        while (action = strtok_r(NULL, " \t\v", &saveptr)) {
                if (!strncmp(action, "->", 2))
                        result.next_mode = action+2;
                else if (!strncmp(action, "extend-mode=", strlen("extend-mode=")))
                        result.extend_mode = action+strlen("extend-mode=");
                else {
                        result.actions[i++] = action;
                        assert(i < 64);
                }
        }

        return result;
}

void clear_mode(const char* mode, const char* next_mode)
{
        for (int i = 0; i < sizeof(KEY_NAMES)/sizeof(KEY_NAMES[0]); i++) {
                char *quoted_key = tmux_quote(KEY_NAMES[i]);
                printf("bind-key -Tcopy-mode-kakoune-%s %s switch-client -Tcopy-mode-kakoune-%s\n",
                        mode, quoted_key, next_mode);
                free(quoted_key);
        }
}

void clear_table(const input_record_t* header)
{
        if (!header->next_mode || !strcmp(header->next_mode, "none"))
                return;
        clear_mode(header->move_mode, header->next_mode);
        if (!header->extend_mode || !strcmp(header->move_mode, header->extend_mode))
                return;
        clear_mode(header->extend_mode, header->next_mode);
}

void make_mapping(const input_record_t* record, const char* mode, const char* key, bool skip_begin_selection)
{
        char *quoted_key = tmux_quote(key);
        printf("bind-key -Tcopy-mode-kakoune-%s %s '\\\n", mode, quoted_key);
        free(quoted_key);

        for (int j = 0; record->actions[j]; j++) {
                if (skip_begin_selection && !strcmp(record->actions[j], "begin-selection"))
                        continue;
                printf("    send-keys -X %s ;\\\n", record->actions[j]);
        }

        if (strcmp(record->next_mode, "none"))
                printf("    switch-client -Tcopy-mode-kakoune-%s ;\\\n", record->next_mode);

        printf("'\n");
}

void make_mappings(const input_record_t* record)
{
        for (int i = 0; record->move_keys[i]; i++)
                make_mapping(record, record->move_mode, record->move_keys[i], false);
        for (int i = 0; record->extend_keys[i]; i++)
                make_mapping(record, record->extend_mode, record->extend_keys[i], true);
}

int main(int argc, char *argv[])
{
        static char file[64 * 1024];
        int result = fread(file, 1, sizeof(file), stdin);
        assert(result > 0);
        assert(result != sizeof(file)); /* Buffer too small */
        file[result] = '\0';

        char *line_saveptr;
        (void)strtok_r(file, "\r\n", &line_saveptr);
        (void)strtok_r(NULL, "\r\n", &line_saveptr);

        char *line;
        input_record_t header = {0};
        while (line = strtok_r(NULL, "\r\n", &line_saveptr)) {
                input_record_t record;

                if (line[0] == '<')
                        continue;
                if (isspace(line[0]))
                        continue;

                record = parse_input_record(line);
                if (!record.move_keys[0] && !record.extend_keys[0]) {
                        header = record;
                        clear_table(&header);
                } else {
                        if (!record.next_mode)
                                record.next_mode = header.next_mode;
                        if (!record.extend_mode)
                                record.extend_mode = header.extend_mode;
                        if (!record.extend_mode)
                                record.extend_mode = record.move_mode;
                        make_mappings(&record);
                }
        }

        exit(EXIT_SUCCESS);
}
