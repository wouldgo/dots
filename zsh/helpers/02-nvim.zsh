#!/usr/bin/env zsh

function __nvim_bootstrap () {
  local NVIM_PATH
  NVIM_PATH="${HOME}/.nvim"

  if [ -d ${NVIM_PATH} ]; then
    path=(
      "${NVIM_PATH}"
      $path)
    export PATH
  fi

  alias vim=nvim
  export EDITOR=nvim
}

__nvim_bootstrap "$@"
