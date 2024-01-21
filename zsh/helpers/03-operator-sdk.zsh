#!/usr/bin/env zsh

function __operator_sdk_boostrap () {
  if [ "$(mise which operator-sdk)" ]; then
    local OPERATOR_SDK=$(mise which operator-sdk)

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_operator-sdk.zsh" ]; then
      "${OPERATOR_SDK}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_operator-sdk.zsh" >/dev/null
    fi
  fi
}

__operator_sdk_boostrap "$@"
