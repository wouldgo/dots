#!/usr/bin/env zsh

function __kubectl_krew_boostrap () {
  if [ $commands[kubectl-krew] ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectl-krew.zsh" ]; then

      kubectl krew completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kubectl-krew.zsh" >/dev/null
    fi

  fi
}

__kubectl_krew_boostrap "$@"
