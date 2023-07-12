#!/usr/bin/env zsh

function __operator_sdk_boostrap () {
  if [ $commands[operator-sdk] ]; then
    if [ ! -f "${HOME}/.zsh/completion/_operator-sdk" ]; then
      operator-sdk completion zsh | tee "${HOME}/.zsh/completion/_operator-sdk" >/dev/null
    fi
  fi
}

__operator_sdk_boostrap "$@"
