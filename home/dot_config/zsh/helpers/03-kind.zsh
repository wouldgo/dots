#!/usr/bin/env zsh

function __kind_bootstrap () {
  if (( $+commands[kind] )); then
    local KIND_BIN=${commands[kind]}

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kind.zsh" ]; then
      "${KIND_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kind.zsh" >/dev/null
    fi
  fi
}

__kind_bootstrap "$@"
