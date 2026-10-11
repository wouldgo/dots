#!/usr/bin/env zsh

function __podman_bootstrap () {

  if [ $commands[podman] ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_podman.zsh" ]; then
    local PODMAN_BIN=$commands[podman]

    ${PODMAN_BIN} completion -f "${ZSH_COMPLETION_FOLDER}/_podman.zsh" zsh
  fi
}

__podman_bootstrap "$@"
