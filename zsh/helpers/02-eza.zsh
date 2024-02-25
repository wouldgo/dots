#!/usr/bin/env zsh

function __eza_bootstrap () {
  if [ "$(mise which -q eza 2> /dev/null)" ]; then
    local EZA_BIN=$(mise which eza)

    alias ls="$EZA_BIN"
  fi
}

__eza_bootstrap "$@"
