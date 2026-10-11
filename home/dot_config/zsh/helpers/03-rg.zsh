#!/usr/bin/env zsh

function __rg_bootstrap () {
  if (( $+commands[rg] )); then
    local RG_COMMAND=${commands[rg]}

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_rg.zsh" ]; then
      rg --generate complete-zsh > "${ZSH_COMPLETION_FOLDER}/_rg.zsh"
    fi
  fi
}

__rg_bootstrap "$@"
