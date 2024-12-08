#!/usr/bin/env zsh

function __rg_bootstrap () {
  if [ "$(mise which -q rg 2> /dev/null)" ]; then
    local RG_COMMAND=$(mise which rg)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_rg.zsh" ]; then
      rg --generate complete-zsh > "${ZSH_COMPLETION_FOLDER}/_rg.zsh"
    fi
  fi
}

__rg_bootstrap "$@"
