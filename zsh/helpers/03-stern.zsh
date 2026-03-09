#!/usr/bin/env zsh

function __stern_boostrap () {
  if [ "$(mise which -q stern 2> /dev/null)" ]; then
    local STERN_BIN=$(mise which stern)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_stern.zsh" ]; then
      "${STERN_BIN}" --completion zsh 2>&1  | tee "${ZSH_COMPLETION_FOLDER}/_stern.zsh" > /dev/null
    fi
  fi
}

__stern_boostrap "$@"
