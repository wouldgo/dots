#!/usr/bin/env zsh

function __pnpm_bootstrap () {
  if (( $+commands[pnpm] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_pnpm.zsh" ];then
    local PNPM_BIN=${commands[pnpm]}

    "${PNPM_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_pnpm.zsh" >/dev/null
  fi
}

__pnpm_bootstrap "$@"
