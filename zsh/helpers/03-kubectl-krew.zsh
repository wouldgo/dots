#!/usr/bin/env zsh

function __kubectl_krew_boostrap () {
  if [ "$(mise which -q krew 2> /dev/null)" ]; then
    local KREW_BIN=$(mise which krew)

    path=(
      $path
      "${KREW_ROOT:-$HOME/.krew}/bin"
    )
    export PATH

    local KREW_PLUGIN_LIST=$("${KREW_BIN}" list 2> /dev/null)

    local VIEW_ALLOCATIONS_INSTALLED=$(echo "${KREW_PLUGIN_LIST}" | grep 'view-allocations' 2> /dev/null)
    if [[ "${VIEW_ALLOCATIONS_INSTALLED}" != "view-allocations" ]]; then
      "${KREW_BIN}" install krew

      "${KREW_BIN}" update
      "${KREW_BIN}" install view-allocations
    fi
  fi
}

__kubectl_krew_boostrap "$@"
