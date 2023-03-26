#!/usr/bin/env zsh

function __rg_bootstrap () {
  local COMPLETION_FOLDER

  COMPLETION_FOLDER="${HOME}/.zsh/completion"
  if [ $commands[rg] ] && [ ! -f "${COMPLETION_FOLDER}/_rg.zsh" ]; then
    (cd "${COMPLETION_FOLDER}"; curl -LOk https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg) && \
    mv "${COMPLETION_FOLDER}/_rg" "${COMPLETION_FOLDER}/_rg.zsh"
  fi
}

__rg_bootstrap "$@"
