#!/usr/bin/env zsh

ZSH_CACHE_DIR="${HOME}/.zsh/_cache"

function __zinit_bootstrap () {
  if [ ! -d "$ZSH_CACHE_DIR" ]; then
    mkdir --parents "$(dirname $ZSH_CACHE_DIR)"
  fi
}

__zinit_bootstrap
