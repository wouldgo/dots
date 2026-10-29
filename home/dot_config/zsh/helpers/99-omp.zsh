#!/usr/bin/env zsh

export OMP_DIR="${HOME}/.omp"

function __omp_bootstrap() {
  if (( $+commands[oh-my-posh] )); then
    local OMP_BIN=${commands[oh-my-posh]}

    # --print prints the whole script: the default goes through a file in
    # ~/.cache/oh-my-posh, and an empty one there is never regenerated
    eval "$(${OMP_BIN} init zsh --print --config ${HOME}/.config/oh-my-posh/omp.yaml)"
  fi
}

__omp_bootstrap "$@"
