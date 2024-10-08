#!/usr/bin/env zsh

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=green,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=red,bold'

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down
