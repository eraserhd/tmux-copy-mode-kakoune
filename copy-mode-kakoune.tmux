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

declare -g CURRENT_TABLE=''
declare -g CURRENT_TABLE_STICKY=0

startTable() {
    CURRENT_TABLE=''
    CURRENT_TABLE_STICKY=0
    while [[ $# -ne 0 ]]; do
        case "$1" in
            -sticky) CURRENT_TABLE_STICKY=1;;
            *)       CURRENT_TABLE="$1";;
        esac
        shift
    done

    if [[ $CURRENT_TABLE_STICKY = 1 ]]; then
        for key_name in "${KEY_NAMES[@]}"; do
            tmux bind-key -T"${CURRENT_TABLE}" "${key_name}" "switch-client -T${CURRENT_TABLE}"
        done
    fi
}

map() {
    local key="$1"
    local commands="$2"
    local stickyCommands=''
    if [[ $CURRENT_TABLE_STICKY = 1 ]]; then
        stickyCommands="switch-client -T${CURRENT_TABLE}"
    fi
    tmux bind-key -T"${CURRENT_TABLE}" "${key}" "
        ${commands}
        ${stickyCommands}
    "
}

addGotoMode() {
    tmux bind-key -Tcopy-mode-kakoune g '
        switch-client -Tcopy-mode-kakoune-g
    '
    startTable copy-mode-kakoune-g
    map Escape '
        switch-client -Tcopy-mode-kakoune
    '
    map g '
        send-keys -X clear-selection
        send-keys -X history-top
    '
    map k '
        send-keys -X clear-selection
        send-keys -X history-top
    '
    map l '
        send-keys -X clear-selection
        send-keys -X end-of-line
        send-keys -X cursor-left
    '
    map h '
        send-keys -X clear-selection
        send-keys -X start-of-line
    '
    map i '
        send-keys -X clear-selection
        send-keys -X back-to-indentation
    '
    map j '
        send-keys -X clear-selection
        send-keys -X history-bottom
        send-keys -X start-of-line
    '
    map e '
        send-keys -X clear-selection
        send-keys -X history-bottom
        send-keys -X end-of-line
        send-keys -X cursor-left
    '
    map t '
        send-keys -X clear-selection
        send-keys -X top-line
    '
    map b '
        send-keys -X clear-selection
        send-keys -X bottom-line
    '
    map c '
        send-keys -X clear-selection
        send-keys -X middle-line
    '
}

addNormalMode() {
    startTable -sticky copy-mode-kakoune
    tmux bind-key -Tcopy-mode-kakoune Escape '
        send-keys -X cancel
    '
    map h '
        send-keys -X clear-selection
        send-keys -X cursor-left
    '
    map j '
        send-keys -X clear-selection
        send-keys -X cursor-down
    '
    map k '
        send-keys -X clear-selection
        send-keys -X cursor-up
    '
    map l '
        send-keys -X clear-selection
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
