#!/usr/bin/env bash

if [ -s "$HOME/.gvm/scripts/gvm" ]; then

  # shellcheck source=/dev/null
  source "${HOME}/.gvm/scripts/gvm"
fi

if [ -f "${HOME}/.gvm/scripts/completion" ]; then

  # shellcheck source=/dev/null
  source "${HOME}/.gvm/scripts/completion"
fi
