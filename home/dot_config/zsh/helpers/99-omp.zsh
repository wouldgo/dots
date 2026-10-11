#!/usr/bin/env zsh

export OMP_DIR="${HOME}/.omp"

function __omp_bootstrap() {
  if (( $+commands[oh-my-posh] )); then
    local OMP_BIN=${commands[oh-my-posh]}

    eval "$(${OMP_BIN} init zsh --config ${HOME}/.config/oh-my-posh/omp.yaml)"
  fi
}

__omp_bootstrap "$@"
