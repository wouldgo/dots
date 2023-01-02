#!/usr/bin/env zsh

function __linkerd_bootstrap () {
  local _LINKERD_FOLDER

  _LINKERD_FOLDER="${HOME}/.linkerd2"
  if [ -d ${_LINKERD_FOLDER} ]; then
    path=(
      "${_LINKERD_FOLDER}/bin"
      $path)
    export PATH
  fi
}

__linkerd_bootstrap "$@"
