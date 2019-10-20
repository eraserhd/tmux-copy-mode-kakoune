bind -Tcopy-mode-kakoune-normal Escape '
    send-keys -X cancel
'
bind -Tcopy-mode-kakoune-normal g '
    switch-client -Tcopy-mode-kakoune-goto
'
bind -Tcopy-mode-kakoune-normal G '
    switch-client -Tcopy-mode-kakoune-goto-extend
'
bind -Tcopy-mode-kakoune-normal , '
    switch-client -Tcopy-mode-kakoune-user
'
bind -Tcopy-mode-kakoune-normal h '
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal Left '
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal j '
    send-keys -X cursor-down
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal Down '
    send-keys -X cursor-down
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal k '
    send-keys -X cursor-up
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal Up '
    send-keys -X cursor-up
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal l '
    send-keys -X cursor-right
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal Right '
    send-keys -X cursor-right
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal Right '
    send-keys -X cursor-right
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal w '
    send-keys -X cursor-right
    send-keys -X begin-selection
    send-keys -X next-word
    send-keys -X cursor-left
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal b '
    send-keys -X begin-selection
    send-keys -X previous-word
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal e '
    send-keys -X begin-selection
    send-keys -X next-word-end
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal % '
    send-keys -X history-top
    send-keys -X start-of-line
    send-keys -X begin-selection
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal M-h '
    send-keys -X begin-selection
    send-keys -X start-of-line
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal M-l '
    send-keys -X begin-selection
    send-keys -X end-of-line
    send-keys -X cursor-left
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal PageUp '
    send-keys -X page-up
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal C-b '
    send-keys -X page-up
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal PageDown '
    send-keys -X page-down
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal C-f '
    send-keys -X page-down
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal C-u '
    send-keys -X halfpage-up
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal C-d '
    send-keys -X halfpage-down
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal ; '
    send-keys -X clear-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal M-; '
    send-keys -X other-end
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-normal y '
    send-keys -X copy-selection-no-clear
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto g '
    send-keys -X history-top
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto G '
    send-keys -X history-top
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto k '
    send-keys -X history-top
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto K '
    send-keys -X history-top
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto l '
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto L '
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto h '
    send-keys -X start-of-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto H '
    send-keys -X start-of-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto i '
    send-keys -X back-to-indentation
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto I '
    send-keys -X back-to-indentation
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto j '
    send-keys -X history-bottom
    send-keys -X start-of-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto J '
    send-keys -X history-bottom
    send-keys -X start-of-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto e '
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto E '
    send-keys -X history-bottom
    send-keys -X end-of-line
    send-keys -X cursor-left
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto t '
    send-keys -X top-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto T '
    send-keys -X top-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto b '
    send-keys -X bottom-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto B '
    send-keys -X bottom-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto c '
    send-keys -X middle-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-goto C '
    send-keys -X middle-line
    send-keys -X begin-selection
    switch-client -Tcopy-mode-kakoune-normal
'
bind -Tcopy-mode-kakoune-user y '
    send-keys -X copy-selection-no-clear
    switch-client -Tcopy-mode-kakoune-normal
'
