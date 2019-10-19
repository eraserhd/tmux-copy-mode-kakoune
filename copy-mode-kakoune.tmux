#!/usr/bin/env bash

readonly KEY_MODIFIERS=( C M S )
readonly KEY_NAMES=(
    F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 IC Insert DC Delete Home End NPage
    PageDown PgDn PPage PageUp PgUp Tab BTab Space BSpace Enter Escape Up Down
    Left Right 'KP/' 'KP*' 'KP-' KP7 KP8 KP9 'KP+' KP4 KP5 KP6 KP1 KP2 KP3
    KPEnter KP0 'KP.'
    '!' '"' '#' '$' '%' '&' "'" '(' ')' '*' '+' ',' '-' '.' '/'
    0 1 2 3 4 5 6 7 8 9
    ':' '\;' '<' '=' '>' '?' '@'
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    '[' ']' '^' '_' '`'
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    '{' '|' '}' '~'
)

declare -g currentTable=''
declare -g currentTableNext=''

startTable() {
    currentTable=''
    currentTableNext=''
    while [[ $# -ne 0 ]]; do
        case "$1" in
            -next)
                currentTableNext="$2"
                shift
                ;;
            *)
                currentTable="$1"
                ;;
        esac
        shift
    done
    for key_name in "${KEY_NAMES[@]}"; do
        tmux bind-key -T"${currentTable}" "${key_name}" "switch-client -T${currentTableNext}"
    done
}

die() {
    tmux display-message "Error! $*"
    exit 1
}

map() {
    local next="${currentTableNext}"
    local key=''
    local commands=''
    while [[ $# -ne 0 ]]; do
        case "$1" in
            -next)
                next="$2"
                shift
                ;;
            -*)
                die 'bad switch'
                ;;
            *)
                if [[ -z $key ]]; then
                    key="$1"
                elif [[ -z $commands ]]; then
                    commands="$1"
                else
                    die 'too many arguments'
                fi
                ;;
        esac
        shift
    done
    if [[ -z $key ]]; then
        die 'no key given'
    fi
    if [[ -z $commands ]]; then
        die 'no commands given'
    fi
    if [[ -n $next ]]; then
        commands="
            ${commands}
            switch-client -T${next}
        "
    fi
    tmux bind-key -T"${currentTable}" "${key}" "${commands}"
}

addGotoMode() {
    tmux bind-key -Tcopy-mode-kakoune g '
        switch-client -Tcopy-mode-kakoune-g
    '
    startTable -next copy-mode-kakoune copy-mode-kakoune-g
    map g '
        send-keys -X history-top
        send-keys -X begin-selection
    '
    map k '
        send-keys -X history-top
        send-keys -X begin-selection
    '
    map l '
        send-keys -X end-of-line
        send-keys -X cursor-left
        send-keys -X begin-selection
    '
    map h '
        send-keys -X start-of-line
        send-keys -X begin-selection
    '
    map i '
        send-keys -X back-to-indentation
        send-keys -X begin-selection
    '
    map j '
        send-keys -X history-bottom
        send-keys -X start-of-line
        send-keys -X begin-selection
    '
    map e '
        send-keys -X history-bottom
        send-keys -X end-of-line
        send-keys -X cursor-left
        send-keys -X begin-selection
    '
    map t '
        send-keys -X top-line
        send-keys -X begin-selection
    '
    map b '
        send-keys -X bottom-line
        send-keys -X begin-selection
    '
    map c '
        send-keys -X middle-line
        send-keys -X begin-selection
    '
}

addNormalMode() {
    startTable -next copy-mode-kakoune copy-mode-kakoune
    map -next '' Escape '
        send-keys -X cancel
    '
    map h '
        send-keys -X cursor-left
        send-keys -X begin-selection
    '
    map H '
        send-keys -X cursor-left
    '
    map j '
        send-keys -X cursor-down
        send-keys -X begin-selection
    '
    map J '
        send-keys -X cursor-down
    '
    map k '
        send-keys -X cursor-up
        send-keys -X begin-selection
    '
    map K '
        send-keys -X cursor-up
    '
    map l '
        send-keys -X cursor-right
        send-keys -X begin-selection
    '
    map L '
        send-keys -X cursor-right
    '
}

addNormalMode
addGotoMode

tmux bind-key -Tprefix '[' '
    copy-mode
    switch-client -Tcopy-mode-kakoune
'
tmux bind-key -Tctrlw N '
    copy-mode
    switch-client -Tcopy-mode-kakoune
'
