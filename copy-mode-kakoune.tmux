#!/usr/bin/env bash

set -e

readonly SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

tmux source "$SCRIPTS/mappings.tmux"
tmux bind-key -Tprefix '[' '
    copy-mode
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
tmux bind-key -Tctrlw N '
    copy-mode
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
