#!/usr/bin/env zsh

function __nvim_bootstrap () {
  if [ "$(mise which -q nvim 2> /dev/null)" ]; then
    local NVIM_BIN=$(mise which nvim)

    alias vim="$NVIM_BIN"
    export EDITOR=$NVIM_BIN
  fi
}

__nvim_bootstrap "$@"
