#!/usr/bin/env zsh

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"

function __cache_dir_bootstrap () {
  if [ ! -d "${ZSH_CACHE_DIR}" ]; then
    mkdir --parents "${ZSH_CACHE_DIR}"
  fi
}

__cache_dir_bootstrap
