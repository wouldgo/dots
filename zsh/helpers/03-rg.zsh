#!/usr/bin/env zsh

function __rg_bootstrap () {
  if [ "$(mise which rg)" ]; then
    local RG_COMMAND=$(mise which rg)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_rg.zsh" ]; then
      (cd "${ZSH_COMPLETION_FOLDER}"; curl -LOk https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg) && \
      mv "${ZSH_COMPLETION_FOLDER}/_rg" "${ZSH_COMPLETION_FOLDER}/_rg.zsh"
    fi
  fi
}

__rg_bootstrap "$@"
