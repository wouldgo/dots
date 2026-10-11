#!/usr/bin/env zsh

function __zoxide_bootstrap () {
  if (( $+commands[zoxide] )); then
    local ZOXIDE_BIN=${commands[zoxide]}

    eval "$(${ZOXIDE_BIN} init --cmd cd zsh)"
  fi
}

__zoxide_bootstrap
