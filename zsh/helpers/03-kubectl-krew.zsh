#!/usr/bin/env zsh

function __kubectl_krew_boostrap () {
  if [ $commands[kubectl-krew] ]; then
    if [ ! -f "${HOME}/.zsh/completion/_kubectl_krew.zsh" ]; then

      kubectl krew completion zsh | tee "${HOME}/.zsh/completion/_kubectl_krew.zsh" >/dev/null
    fi

  fi
}

__kubectl_krew_boostrap "$@"
