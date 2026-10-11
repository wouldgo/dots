#!/usr/bin/env zsh

function __argocd_bootstrap () {
  if (( $+commands[argocd] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_argocd.zsh" ];then
    local ARGOCD_BIN=${commands[argocd]}

    "${ARGOCD_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_argocd.zsh" >/dev/null
  fi
}

__argocd_bootstrap "$@"
