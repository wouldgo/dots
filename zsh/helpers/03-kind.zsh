#!/usr/bin/env zsh

function __kind_bootstrap () {
  if [ "$(mise which -q kind 2> /dev/null)" ]; then
    local KIND_BIN=$(mise which kind)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_kind.zsh" ]; then
      "${KIND_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_kind.zsh" >/dev/null
    fi
  fi
}

__kind_bootstrap "$@"
