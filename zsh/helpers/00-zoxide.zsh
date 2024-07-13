#!/usr/bin/env zsh

function __zoxide_bootstrap () {
  if [ "$(mise which -q zoxide 2> /dev/null)" ]; then
    local ZOXIDE_BIN=$(mise which zoxide)

    eval "$(${ZOXIDE_BIN} init --cmd cd zsh)"
  fi
}

__zoxide_bootstrap
