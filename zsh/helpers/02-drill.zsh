#!/usr/bin/env zsh

function __drill_bootstrap () {
  if [ "$(command -v drill 2> /dev/null)" ]; then
    local DRILL_BIN=$(command -v drill)

    alias dig="$DRILL_BIN"
  fi
}

__drill_bootstrap "$@"
