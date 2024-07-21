#!/usr/bin/env zsh

export OMP_DIR="${HOME}/.omp/"

function __omp_bootstrap() {

  if [ -f "${OMP_DIR}/oh-my-posh" ]; then
    PATH="${PATH}:${OMP_DIR}"

    eval "$(${OMP_DIR}/oh-my-posh init zsh --config ${DOTS_FOLDER}/omp.toml )"

    if [ ! -f "${ZSH_COMPLETION_FOLDER}/_oh-my-posh.zsh" ]; then
      "${OMP_DIR}/oh-my-posh" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_oh-my-posh.zsh" >/dev/null
    fi
  fi
}

__omp_bootstrap "$@"
