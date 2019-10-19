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

table() {
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
    local isMove=0
    while [[ $# -ne 0 ]]; do
        case "$1" in
            -extend)
                ;;
            -move)
                isMove=1
                ;;
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
                else
                    commands="${commands}
                        send-keys -X $1"
                fi
                ;;
        esac
        shift
    done
    if [[ -z $key ]]; then
        die 'no key given'
    fi
    if [[ $isMove -eq 1 ]]; then
        commands="
            ${commands}
            send-keys -X begin-selection
        "
    fi
    if [[ -n $next ]]; then
        commands="
            ${commands}
            switch-client -T${next}
        "
    fi
    tmux bind-key -T"${currentTable}" "${key}" "${commands}"
}

addGotoModeKeys() {
    local moveOrExtend="$1"
    map $moveOrExtend g history-top
    map $moveOrExtend G history-top
    map $moveOrExtend k history-top
    map $moveOrExtend K history-top
    map $moveOrExtend l end-of-line cursor-left
    map $moveOrExtend L end-of-line cursor-left
    map $moveOrExtend h start-of-line
    map $moveOrExtend H start-of-line
    map $moveOrExtend i back-to-indentation
    map $moveOrExtend I back-to-indentation
    map $moveOrExtend j history-bottom start-of-line
    map $moveOrExtend J history-bottom start-of-line
    map $moveOrExtend e history-bottom end-of-line cursor-left
    map $moveOrExtend E history-bottom end-of-line cursor-left
    map $moveOrExtend t top-line
    map $moveOrExtend T top-line
    map $moveOrExtend b bottom-line
    map $moveOrExtend B bottom-line
    map $moveOrExtend c middle-line
    map $moveOrExtend C middle-line
}

addGotoModes() {
    table -next copy-mode-kakoune copy-mode-kakoune-goto
    addGotoModeKeys -move
    table -next copy-mode-kakoune copy-mode-kakoune-goto-extend
    addGotoModeKeys -extend
}

addNormalMode() {
    table -next copy-mode-kakoune copy-mode-kakoune
    map -next '' Escape cancel
    map -next copy-mode-kakoune-goto g
    map -next copy-mode-kakoune-goto-extend G
    map -move   h cursor-left
    map -extend H cursor-left
    map -move   j cursor-down
    map -extend J cursor-down
    map -move   k cursor-up
    map -extend K cursor-up
    map -move   l cursor-right
    map -extend L cursor-right
}

addNormalMode
addGotoModes

tmux bind-key -Tprefix '[' '
    copy-mode
    switch-client -Tcopy-mode-kakoune
'
tmux bind-key -Tctrlw N '
    copy-mode
    switch-client -Tcopy-mode-kakoune
'
