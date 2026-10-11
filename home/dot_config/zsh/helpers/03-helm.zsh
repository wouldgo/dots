#!/usr/bin/env zsh

function __helm_bootstrap () {
  if (( $+commands[helm] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_helm.zsh" ]; then
    local HELM_BIN=${commands[helm]}

    "${HELM_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_helm.zsh" >/dev/null
  fi
}

__helm_bootstrap "$@"
