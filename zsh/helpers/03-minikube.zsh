#!/usr/bin/env zsh

function __minikube_bootstrap () {
  if [ "$(mise which -q minikube 2> /dev/null)" ]; then
    local MINIKUBE_BIN=$(mise which minikube)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_minikube.zsh" ]; then
      "${MINIKUBE_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_minikube.zsh" >/dev/null
    fi
  fi
}

__minikube_bootstrap "$@"
