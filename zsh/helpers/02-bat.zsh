#!/usr/bin/env zsh

function __bat_bootstrap () {
  if [ "$(mise which -q bat 2> /dev/null)" ]; then
    local BAT_BIN=$(mise which bat)

    alias cat="$BAT_BIN"
  fi
}

__bat_bootstrap "$@"
