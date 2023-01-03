#!/usr/bin/env bash

function __fzf_boostrap() {
  if [ -f "${HOME}/.fzf.zsh" ]; then

    #shellcheck source=/dev/null
    source "${HOME}/.fzf.zsh"
  fi
}

__fzf_boostrap "$@"
