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
    map -move   h cursor-left
    map -extend H cursor-left
    map -move   j cursor-down
    map -extend J cursor-down
    map -move   k cursor-up
    map -extend K cursor-up
    map -move   l cursor-right
    map -extend L cursor-right
    map         w cursor-right begin-selection next-word cursor-left
    map -extend W cursor-right next-word cursor-left
}

addEntryPoints() {
    tmux bind-key -Tprefix '[' '
        copy-mode
        switch-client -Tcopy-mode-kakoune
    '
    tmux bind-key -Tctrlw N '
        copy-mode
        switch-client -Tcopy-mode-kakoune
    '
}

addNormalMode
addGotoModes
addEntryPoints
