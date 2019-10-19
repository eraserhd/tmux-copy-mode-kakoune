#!/usr/bin/env bash

tmux bind -Tcopy-mode-vi g switch-client -Tcopy-mode-kakoune-g
tmux bind -Tcopy-mode-kakoune-g g send-keys -X history-top
tmux bind -Tcopy-mode-kakoune-g k send-keys -X history-top
tmux bind -Tcopy-mode-kakoune-g l send-keys -X end-of-line \; send-keys -X cursor-left
tmux bind -Tcopy-mode-kakoune-g h send-keys -X start-of-line
tmux bind -Tcopy-mode-kakoune-g i send-keys -X back-to-indentation
tmux bind -Tcopy-mode-kakoune-g j send-keys -X history-bottom \; send-keys -X start-of-line
tmux bind -Tcopy-mode-kakoune-g e send-keys -X history-bottom \; send-keys -X end-of-line \; send-keys -X cursor-left
tmux bind -Tcopy-mode-kakoune-g t send-keys -X top-line
tmux bind -Tcopy-mode-kakoune-g b send-keys -X bottom-line
tmux bind -Tcopy-mode-kakoune-g c send-keys -X middle-line
