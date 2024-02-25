#!/usr/bin/env zsh

function __kubectl_boostrap () {
  if [ "$(mise which -q kubectl 2> /dev/null)" ]; then
    local KUBECTL_BIN=$(mise which kubectl)

    alias k="$KUBECTL_BIN"

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectl.zsh" ]; then
      "${$KUBECTL_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kubectl.zsh" >/dev/null
    fi
  fi
}

__kubectl_boostrap "$@"
