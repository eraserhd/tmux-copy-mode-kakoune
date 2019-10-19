
die() {
    tmux display-message "Error! $*"
    exit 1
}
