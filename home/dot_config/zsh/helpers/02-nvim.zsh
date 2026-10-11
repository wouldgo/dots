#!/usr/bin/env zsh

function __nvim_bootstrap () {
  if (( $+commands[nvim] )); then
    local NVIM_BIN=${commands[nvim]}

    alias vim="$NVIM_BIN"
    export EDITOR=$NVIM_BIN
  fi
}

__nvim_bootstrap "$@"
