#!/usr/bin/env zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

function __zinit_bootstrap () {
  if [ ! -d "$ZINIT_HOME" ]; then
    mkdir --parents "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
  fi

  source "${ZINIT_HOME}/zinit.zsh"
}

__zinit_bootstrap
