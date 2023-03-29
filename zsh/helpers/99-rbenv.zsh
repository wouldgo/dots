#!/usr/bin/env zsh

export RBENV_ROOT="${HOME}/.rbenv"
export RBENV_BIN="${RBENV_ROOT}/bin"

if [ -d "${RBENV_BIN}" ]; then
  path=("${RBENV_BIN}" $path)
  export PATH

  eval "$(rbenv init -)"
fi
