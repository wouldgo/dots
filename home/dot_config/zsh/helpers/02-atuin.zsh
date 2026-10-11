#!/usr/bin/env zsh

function __atuin_bootstrap () {
  if (( $+commands[atuin] )); then
    local ATUIN_BIN=${commands[atuin]}

    eval "$(${ATUIN_BIN} init --disable-ai --disable-up-arrow zsh)"

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_atuin.zsh" ]; then

      ${ATUIN_BIN} gen-completions --shell zsh > "${ZSH_COMPLETION_FOLDER}/_atuin.zsh"
    fi
  fi
}

__atuin_bootstrap
