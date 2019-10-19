#!/usr/bin/env bash

addGotoMode() {
    tmux bind-key -Tcopy-mode-kakoune-g g '
        send-keys -X clear-selection
        send-keys -X history-top
    '
    tmux bind-key -Tcopy-mode-kakoune-g k '
        send-keys -X clear-selection
        send-keys -X history-top
    '
    tmux bind-key -Tcopy-mode-kakoune-g l '
        send-keys -X clear-selection
        send-keys -X end-of-line
        send-keys -X cursor-left
    '
    tmux bind-key -Tcopy-mode-kakoune-g h '
        send-keys -X clear-selection
        send-keys -X start-of-line
    '
    tmux bind-key -Tcopy-mode-kakoune-g i '
        send-keys -X clear-selection
        send-keys -X back-to-indentation
    '
    tmux bind-key -Tcopy-mode-kakoune-g j '
        send-keys -X clear-selection
        send-keys -X history-bottom
        send-keys -X start-of-line
    '
    tmux bind-key -Tcopy-mode-kakoune-g e '
        send-keys -X clear-selection
        send-keys -X history-bottom
        send-keys -X end-of-line
        send-keys -X cursor-left
    '
    tmux bind-key -Tcopy-mode-kakoune-g t '
        send-keys -X clear-selection
        send-keys -X top-line
    '
    tmux bind-key -Tcopy-mode-kakoune-g b '
        send-keys -X clear-selection
        send-keys -X bottom-line
    '
    tmux bind-key -Tcopy-mode-kakoune-g c '
        send-keys -X clear-selection
        send-keys -X middle-line
    '
}

addGotoMode
tmux bind-key -Tcopy-mode-vi g switch-client -Tcopy-mode-kakoune-g
