#!/usr/bin/env zsh

function __eza_bootstrap () {
  if (( $+commands[eza] )); then
    local EZA_BIN=${commands[eza]}

    alias ls="$EZA_BIN --group"
  fi
}

__eza_bootstrap "$@"
