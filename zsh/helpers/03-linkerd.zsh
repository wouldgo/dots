#!/usr/bin/env zsh

function __linkerd_bootstrap () {
  if [ "$(mise which -q linkerd 2> /dev/null)" ]; then

    local LINKERD_BIN=$(mise which linkerd)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_linkerd.zsh" ]; then
      "${LINKERD_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_linkerd.zsh" >/dev/null
    fi
  fi
}

__linkerd_bootstrap "$@"
