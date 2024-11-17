#!/usr/bin/env zsh

function __fzf_bootstrap () {
  if [ -d "${HOME}/.fzf" ]; then
    path=(
      "${HOME}/.fzf/bin"
      $path
    )
    export PATH
  fi
}

__fzf_bootstrap "$@"
