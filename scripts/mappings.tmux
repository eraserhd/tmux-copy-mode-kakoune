bind-key -Tcopy-mode-vi 'Escape' {
    send-keys -X cancel
}
bind-key -Tcopy-mode-vi 'g' {
    switch-client -Tcopy-mode-kakoune-goto
}
bind-key -Tcopy-mode-vi 'G' {
    switch-client -Tcopy-mode-kakoune-goto-extend
}
bind-key -Tcopy-mode-vi ',' {
    switch-client -Tcopy-mode-kakoune-user
}
bind-key -Tcopy-mode-vi 'h' {
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'Left' {
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'H' {
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'S-Left' {
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'j' {
    send-keys -X cursor-down
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'Down' {
    send-keys -X cursor-down
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'J' {
    send-keys -X cursor-down
}
bind-key -Tcopy-mode-vi 'S-Down' {
    send-keys -X cursor-down
}
bind-key -Tcopy-mode-vi 'k' {
    send-keys -X cursor-up
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'Up' {
    send-keys -X cursor-up
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'K' {
    send-keys -X cursor-up
}
bind-key -Tcopy-mode-vi 'S-Up' {
    send-keys -X cursor-up
}
bind-key -Tcopy-mode-vi 'l' {
    send-keys -X cursor-right
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'Right' {
    send-keys -X cursor-right
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'L' {
    send-keys -X cursor-right
}
bind-key -Tcopy-mode-vi 'S-Right' {
    send-keys -X cursor-right
}
bind-key -Tcopy-mode-vi 'w' {
    send-keys -X cursor-right
    send-keys -X begin-selection
    send-keys -X next-word
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'W' {
    send-keys -X cursor-right
    send-keys -X next-word
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'b' {
    send-keys -X begin-selection
    send-keys -X previous-word
}
bind-key -Tcopy-mode-vi 'B' {
    send-keys -X previous-word
}
bind-key -Tcopy-mode-vi 'e' {
    send-keys -X begin-selection
    send-keys -X next-word-end
}
bind-key -Tcopy-mode-vi 'E' {
    send-keys -X next-word-end
}
bind-key -Tcopy-mode-vi 'f' {
    command-prompt -1 -p "(select onto next char)" {
        send-keys -X begin-selection
        send-keys -X jump-forward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'F' {
    command-prompt -1 -p "(extend onto next char)" {
        send-keys -X jump-forward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'M-f' {
    command-prompt -1 -p "(select onto previous char)" {
        send-keys -X begin-selection
        send-keys -X jump-backward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'M-F' {
    command-prompt -1 -p "(extend onto previous char)" {
        send-keys -X jump-backward "%%%"
    }
}
bind-key -Tcopy-mode-vi 't' {
    command-prompt -1 -p "(select to next char)" {
        send-keys -X begin-selection
        send-keys -X jump-to-forward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'T' {
    command-prompt -1 -p "(extend to next char)" {
        send-keys -X jump-to-forward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'M-t' {
    command-prompt -1 -p "(select to previous char)" {
        send-keys -X begin-selection
        send-keys -X jump-to-backward "%%%"
    }
}
bind-key -Tcopy-mode-vi 'M-T' {
    command-prompt -1 -p "(extend to previous char)" {
        send-keys -X jump-to-backward "%%%"
    }
}
bind-key -Tcopy-mode-vi '%' {
    send-keys -X history-top
    send-keys -X start-of-line
    send-keys -X begin-selection
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'M-h' {
    send-keys -X begin-selection
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-vi 'M-H' {
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-vi 'M-l' {
    send-keys -X begin-selection
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'M-L' {
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-vi 'PageUp' {
    send-keys -X page-up
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'C-b' {
    send-keys -X page-up
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'PageDown' {
    send-keys -X page-down
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'C-f' {
    send-keys -X page-down
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'C-u' {
    send-keys -X halfpage-up
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'C-d' {
    send-keys -X halfpage-down
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi ';' {
    send-keys -X clear-selection
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-vi 'M-;' {
    send-keys -X other-end
}
bind-key -Tcopy-mode-vi 'y' {
    send-keys -X copy-selection-no-clear
    send-keys -X cancel
}
bind-key -Tcopy-mode-vi 'M-y' {
    send-keys -X copy-selection-no-clear
}
bind-key -Tcopy-mode-kakoune-goto 'g' {
    send-keys -X history-top
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'G' {
    send-keys -X history-top
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'k' {
    send-keys -X history-top
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'K' {
    send-keys -X history-top
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'g' {
    send-keys -X history-top
}
bind-key -Tcopy-mode-kakoune-goto-extend 'G' {
    send-keys -X history-top
}
bind-key -Tcopy-mode-kakoune-goto-extend 'k' {
    send-keys -X history-top
}
bind-key -Tcopy-mode-kakoune-goto-extend 'K' {
    send-keys -X history-top
}
bind-key -Tcopy-mode-kakoune-goto 'l' {
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'L' {
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'l' {
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-kakoune-goto-extend 'L' {
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-kakoune-goto 'h' {
    send-keys -X start-of-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'H' {
    send-keys -X start-of-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'h' {
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-kakoune-goto-extend 'H' {
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-kakoune-goto 'i' {
    send-keys -X back-to-indentation
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'I' {
    send-keys -X back-to-indentation
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'i' {
    send-keys -X back-to-indentation
}
bind-key -Tcopy-mode-kakoune-goto-extend 'I' {
    send-keys -X back-to-indentation
}
bind-key -Tcopy-mode-kakoune-goto 'j' {
    send-keys -X history-bottom
    send-keys -X start-of-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'J' {
    send-keys -X history-bottom
    send-keys -X start-of-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'j' {
    send-keys -X history-bottom
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-kakoune-goto-extend 'J' {
    send-keys -X history-bottom
    send-keys -X start-of-line
}
bind-key -Tcopy-mode-kakoune-goto 'e' {
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'E' {
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'e' {
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-kakoune-goto-extend 'E' {
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
}
bind-key -Tcopy-mode-kakoune-goto 't' {
    send-keys -X top-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'T' {
    send-keys -X top-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 't' {
    send-keys -X top-line
}
bind-key -Tcopy-mode-kakoune-goto-extend 'T' {
    send-keys -X top-line
}
bind-key -Tcopy-mode-kakoune-goto 'b' {
    send-keys -X bottom-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'B' {
    send-keys -X bottom-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'b' {
    send-keys -X bottom-line
}
bind-key -Tcopy-mode-kakoune-goto-extend 'B' {
    send-keys -X bottom-line
}
bind-key -Tcopy-mode-kakoune-goto 'c' {
    send-keys -X middle-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto 'C' {
    send-keys -X middle-line
    send-keys -X begin-selection
}
bind-key -Tcopy-mode-kakoune-goto-extend 'c' {
    send-keys -X middle-line
}
bind-key -Tcopy-mode-kakoune-goto-extend 'C' {
    send-keys -X middle-line
}
bind-key -Tcopy-mode-kakoune-user 'y' {
    send-keys -X copy-selection-no-clear
    run-shell "#{@copy_mode_kakoune_scripts}/after-yank"
    send-keys -X cancel
}
bind-key -Tcopy-mode-kakoune-user 'M-y' {
    send-keys -X copy-selection-no-clear
    run-shell "#{@copy_mode_kakoune_scripts}/after-yank"
}
