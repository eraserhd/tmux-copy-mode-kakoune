#define _XOPEN_SOURCE 600

#include <assert.h>
#include <ctype.h>
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct input_record_tag {
        char *mode;
        char *next_mode;
        char *extend_mode;
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
        result.mode = strtok_r(line, " \t\v", &saveptr);
        assert(result.mode);

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

void make_mappings(const input_record_t* record)
{
        for (int i = 0; record->move_keys[i]; i++) {
                char *quoted_key = tmux_quote(record->move_keys[i]);
                printf("bind-key -Tcopy-mode-kakoune-%s %s '\\\n", record->mode, quoted_key);
                free(quoted_key);
                for (int j = 0; record->actions[j]; j++)
                        printf("    send-keys -X %s ;\\\n", record->actions[j]);
                if (strcmp(record->next_mode, "none"))
                        printf("    switch-client -Tcopy-mode-kakoune-%s ;\\\n", record->next_mode);
                printf("'\n");
        }
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
                if (!record.move_keys[0] && !record.extend_keys[0])
                        header = record;
                else {
                        if (!record.next_mode)
                                record.next_mode = header.next_mode;
                        if (!record.extend_mode)
                                record.extend_mode = header.extend_mode;
                        make_mappings(&record);
                }
        }

        exit(EXIT_SUCCESS);
}
