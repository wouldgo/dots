#!/usr/bin/env zsh

function __linkerd_bootstrap () {

  if [ "$(rtx which linkerd)" ]; then
    local LINKERD_BIN=$(rtx which linkerd)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_linkerd.zsh" ]; then
      "${LINKERD_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_linkerd.zsh" >/dev/null
    fi
  fi
}

__linkerd_bootstrap "$@"
