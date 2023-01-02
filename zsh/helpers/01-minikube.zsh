#!/usr/bin/env zsh

function __minikube_bootstrap () {
  if [ $commands[minikube] ]; then
    if [ ! -f "${HOME}/.zsh/completion/_minikube.zsh" ]; then
      minikube completion zsh | tee "${HOME}/.zsh/completion/_minikube.zsh" >/dev/null
    fi
  fi
}

__minikube_bootstrap "$@"
