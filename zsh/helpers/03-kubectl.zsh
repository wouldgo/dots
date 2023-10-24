#!/usr/bin/env zsh

function __kubectl_boostrap () {
  if [ $commands[kubectl] ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectl.zsh" ]; then
      kubectl completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kubectl.zsh" >/dev/null
    fi

    alias k=kubectl
  fi
}

__kubectl_boostrap "$@"
