#!/usr/bin/env zsh

function __minikube_bootstrap () {
  if [ $commands[minikube] ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_minikube.zsh" ]; then
      minikube completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_minikube.zsh" >/dev/null
    fi
  fi
}

__minikube_bootstrap "$@"
