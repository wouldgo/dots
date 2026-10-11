#!/usr/bin/env zsh

function __drill_bootstrap () {
  if (( $+commands[drill] )); then
    local DRILL_BIN=${commands[drill]}

    alias dig="$DRILL_BIN"
  fi
}

__drill_bootstrap "$@"
