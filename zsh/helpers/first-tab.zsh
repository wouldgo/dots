#!/usr/bin/env zsh

first-tab() {
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls -al "
    CURSOR=7
    zle list-choices
  else
    zle expand-or-complete
  fi
}
