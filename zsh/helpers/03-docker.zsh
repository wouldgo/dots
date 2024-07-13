#!/usr/bin/env zsh

function __docker_bootstrap () {
  if [ $commands[docker] ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_docker.zsh" ]; then
      docker completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_docker.zsh" > /dev/null
    fi
  fi
}

__docker_bootstrap "$@"
