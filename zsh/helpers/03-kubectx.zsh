#!/usr/bin/env zsh

function __kubectx_and_kubens_bootstrap () {
  if [ "$(mise which -q kubectx 2> /dev/null)" ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh" ]; then
      ln -sf "${ZSHRC_CONFS_FOLDER}/completion/_kubectx.zsh" "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh"
    fi
  fi

  if [ "$(mise which -q kubens 2> /dev/null)" ]; then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubens.zsh" ]; then
      ln -sf "${ZSHRC_CONFS_FOLDER}/completion/_kubens.zsh" "${ZSH_COMPLETION_FOLDER}/_kubens.zsh"
    fi
  fi
}

__kubectx_and_kubens_bootstrap "$@"
