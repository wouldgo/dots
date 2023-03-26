#!/usr/bin/env zsh

function __kubectl_boostrap () {
  if [ $commands[kubectl] ]; then
    if [ ! -f "${HOME}/.zsh/completion/_kubectl.zsh" ]; then
      kubectl completion zsh | tee "${HOME}/.zsh/completion/_kubectl.zsh" >/dev/null
    fi

    alias k=kubectl
  fi
}

__kubectl_boostrap "$@"
