#!/usr/bin/env bash

function __ng_bootstrap () {
  if (( $+commands[ng] )); then
    local NG_COMMAND=${commands[ng]}

    source <(${NG_COMMAND} completion script)
  fi
}

__ng_bootstrap "$@"
