#!/usr/bin/env zsh

function __helm_bootstrap () {
  if [ "$(mise which -q helm 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_helm.zsh" ];then
    local HELM_BIN=$(mise which helm)

    "${HELM_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_helm.zsh" >/dev/null
  fi
}

__helm_bootstrap "$@"
