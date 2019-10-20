#!/usr/bin/env bash

readonly SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

source "$SCRIPTS/functions.bash"
source "$SCRIPTS/mapping.bash"

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
    map -move   h        cursor-left
    map -extend H        cursor-left
    map -move   Left     cursor-left
    map -extend S-Left   cursor-left
    map -move   j        cursor-down
    map -extend J        cursor-down
    map -move   Down     cursor-down
    map -extend S-Down   cursor-down
    map -move   k        cursor-up
    map -extend K        cursor-up
    map -move   Up       cursor-up
    map -extend S-Up     cursor-up
    map -move   l        cursor-right
    map -extend L        cursor-right
    map -move   Right    cursor-right
    map -extend S-Right  cursor-right
    map         w        cursor-right begin-selection next-word cursor-left
    map -extend W        cursor-right next-word cursor-left
    map         b        begin-selection previous-word
    map -extend B        previous-word
    map         e        begin-selection next-word-end
    map -extend E        next-word-end
    map         %        history-top start-of-line begin-selection history-bottom end-of-line cursor-left
    map         M-h      begin-selection start-of-line
    map -extend M-H      start-of-line
    map         M-l      begin-selection end-of-line cursor-left
    map -extend M-L      end-of-line cursor-left
    map -move   PageUp   page-up
    map -move   C-b      page-up
    map -move   PageDown page-down
    map -move   C-f      page-down
    map -move   C-u      halfpage-up
    map -move   C-d      halfpage-down
    map         '\;'     clear-selection
    map         'M-\;'   other-end
    map         y        copy-selection-no-clear
}

addEntryPoints() {
    tmux bind-key -Tprefix '[' '
        copy-mode
        send-keys -X begin-selection
        switch-client -Tcopy-mode-kakoune
    '
    tmux bind-key -Tctrlw N '
        copy-mode
        send-keys -X begin-selection
        switch-client -Tcopy-mode-kakoune
    '
}

addNormalMode
addGotoModes
addEntryPoints
