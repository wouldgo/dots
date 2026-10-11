#!/usr/bin/env zsh

function __kubectx_and_kubens_bootstrap () {
  if (( $+commands[kubectx] )); then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh" ]; then
      ln -sf "${ZSHRC_CONFS_FOLDER}/share/_kubectx.zsh" "${ZSH_COMPLETION_FOLDER}/_kubectx.zsh"
    fi
  fi

  if (( $+commands[kubens] )); then
    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kubens.zsh" ]; then
      ln -sf "${ZSHRC_CONFS_FOLDER}/share/_kubens.zsh" "${ZSH_COMPLETION_FOLDER}/_kubens.zsh"
    fi
  fi
}

__kubectx_and_kubens_bootstrap "$@"
