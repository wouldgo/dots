#!/usr/bin/env zsh

function __kubens_boostrap () {
  if [ "$(mise which -q kubens 2> /dev/null)" ]; then
    local KUBENS_FOLDER=$(mise where kubens)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh" ]; then
      cat "${KUBENS_FOLDER}/completion/_kubectx.zsh" | tee "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh" > /dev/null
    fi

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubens.zsh" ]; then
      cat "${KUBENS_FOLDER}/completion/_kubens.zsh" | tee "${ZSH_COMPLETION_FOLDER}/_kubens.zsh" > /dev/null
    fi
  fi
}

__kubens_boostrap "$@"
