#!/usr/bin/env zsh

function __kubectl_krew_boostrap () {
  if [ "$(mise which -q krew 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectl-krew.zsh" ]; then
    local KREW_BIN=$(mise which helm)

    "${KREW_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kubectl-krew.zsh" >/dev/null
  fi
}

__kubectl_krew_boostrap "$@"
