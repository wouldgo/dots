#!/usr/bin/env zsh

ZSH_COMPLETION_FOLDER=${HOME}/.zsh/completion

function __zsh_completion_bootstrap () {
  if [ ! -d "$ZSH_COMPLETION_FOLDER" ]; then
    mkdir --parents "${ZSH_COMPLETION_FOLDER}"
  fi
}

__zsh_completion_bootstrap
