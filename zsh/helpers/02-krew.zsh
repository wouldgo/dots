#!/usr/bin/env zsh

function __krew_bootstrap () {
  local _KREW_FOLDER
  _KREW_FOLDER="${HOME}/.krew"

  if [ -d ${_KREW_FOLDER} ]; then
    path=(
      "${_KREW_FOLDER}/bin"
      $path)
    export PATH
  fi
}

__krew_bootstrap "$@"
