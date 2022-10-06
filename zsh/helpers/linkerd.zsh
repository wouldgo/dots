#!/usr/bin/env zsh

_LINKERD_FOLDER="${HOME}/.linkerd2"

if [ -d ${_LINKERD_FOLDER} ]; then
  path=(
    "${_LINKERD_FOLDER}/bin"
    $path)
  export PATH
fi
