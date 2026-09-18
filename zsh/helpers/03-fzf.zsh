#!/usr/bin/env zsh

function __fzf_bootstrap () {
  if [ -d "${HOME}/.fzf" ]; then
    path=(
      $path
      "${HOME}/.fzf/bin"
    )
    export PATH
  fi
}

__fzf_bootstrap "$@"
