#!/usr/bin/env zsh

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=green,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=red,bold'

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
