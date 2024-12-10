#!/usr/bin/env zsh

function __argocd_bootstrap () {
  if [ "$(mise which -q argocd 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_argocd.zsh" ];then
    local ARGOCD_BIN=$(mise which argocd)

    "${ARGOCD_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_argocd.zsh" >/dev/null
  fi
}

__argocd_bootstrap "$@"
