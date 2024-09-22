#!/usr/bin/env zsh

function __pnpm_bootstrap () {
  if [ "$(mise which -q pnpm 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_pnpm.zsh" ];then
    local PNPM_BIN=$(mise which pnpm)

    "${PNPM_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_pnpm.zsh" >/dev/null
  fi
}

__pnpm_bootstrap "$@"
