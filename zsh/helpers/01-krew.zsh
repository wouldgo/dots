#!/usr/bin/env zsh

_KREW_FOLDER="${HOME}/.krew"

if [ -d ${_KREW_FOLDER} ]; then
  path=(
    "${_KREW_FOLDER}/bin"
    $path)
  export PATH
fi
