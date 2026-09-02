#!/usr/bin/env zsh

ZSH_CACHE_DIR="${HOME}/.zsh/_cache"

function __cache_dir_bootstrap () {
  if [ ! -d "${ZSH_CACHE_DIR}" ]; then
    mkdir --parents "${ZSH_CACHE_DIR}"
  fi
}

__cache_dir_bootstrap
