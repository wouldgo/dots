#!/usr/bin/env zsh

function __oc_boostrap () {
  if (( $+commands[oc] )); then
    local OC_BIN=${commands[oc]}

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_oc.zsh" ]; then
      "${OC_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_oc.zsh" > /dev/null
    fi
  fi
}

__oc_boostrap "$@"
