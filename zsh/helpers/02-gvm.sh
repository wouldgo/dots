#!/usr/bin/env bash

if [ -f "${HOME}/.gvm/scripts/completion" ]; then
  export GVM_ROOT="${HOME}/.gvm"

  # shellcheck source=/dev/null
  source "${HOME}/.gvm/scripts/completion"
fi
