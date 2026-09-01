#!/usr/bin/env zsh

function __atuin_bootstrap () {
  if [ "$(mise which -q atuin 2> /dev/null)" ]; then
    ATUIN_HISTORY_SEARCH_FILTER_MODE="global"
    local ATUIN_BIN=$(mise which atuin)

    eval "$(${ATUIN_BIN} init --disable-ai --disable-up-arrow zsh)"
  fi


  if [ ! -f "${ZSH_COMPLETION_FOLDER}/_atuin.zsh" ]; then

    ${ATUIN_BIN} gen-completions --shell zsh > "${ZSH_COMPLETION_FOLDER}/_atuin.zsh"
  fi
}

__atuin_bootstrap
