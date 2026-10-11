#!/usr/bin/env zsh

function __stern_boostrap () {
  if (( $+commands[stern] )); then
    local STERN_BIN=${commands[stern]}

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_stern.zsh" ]; then
      "${STERN_BIN}" --completion zsh 2>&1  | tee "${ZSH_COMPLETION_FOLDER}/_stern.zsh" > /dev/null
    fi
  fi
}

__stern_boostrap "$@"
