#!/usr/bin/env zsh

__first_tab() {
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls -al "
    CURSOR=7
    zle list-choices
  else
    zle expand-or-complete
  fi
}
