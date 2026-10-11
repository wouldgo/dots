#!/usr/bin/env zsh

function __bat_bootstrap () {
  if (( $+commands[bat] )); then
    local BAT_BIN=${commands[bat]}

    alias less="$BAT_BIN"
  fi
}

__bat_bootstrap "$@"
