
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
