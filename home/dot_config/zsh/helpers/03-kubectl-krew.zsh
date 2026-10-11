#!/usr/bin/env zsh

function __kubectl_krew_boostrap () {
  if (( $+commands[krew] )); then
    local KREW_BIN=${commands[krew]}

    path=(
      $path
      "${KREW_ROOT:-$HOME/.krew}/bin"
    )
    export PATH

    if [ ! -d "${KREW_ROOT:-$HOME/.krew}/store/view-allocations" ]; then
      "${KREW_BIN}" install krew

      "${KREW_BIN}" update
      "${KREW_BIN}" install view-allocations
    fi
  fi
}

__kubectl_krew_boostrap "$@"
