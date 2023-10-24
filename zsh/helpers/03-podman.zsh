#!/usr/bin/env zsh

function __podman_bootstrap () {
  if [ $commands[podman] ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_podman.zsh" ]; then
      podman completion -f "${ZSH_COMPLETION_FOLDER}/_podman.zsh" zsh
    fi
  fi
}

__podman_bootstrap "$@"
