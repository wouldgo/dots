#!/usr/bin/env zsh

function __helm_bootstrap () {
  if [ $commands[helm] ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_helm.zsh" ]; then
    helm completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_helm.zsh" >/dev/null
  fi
}

__helm_bootstrap "$@"
