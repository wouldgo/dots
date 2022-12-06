#!/usr/bin/env bash

function __conda_bootstrap() {
  local CONDA_EXEC

  CONDA_EXEC="${HOME}/.miniforge3/bin/conda"

  if [ -f "${CONDA_EXEC}" ]; then
    if [ ! -f "${ZSH_CACHE_DIR}/conda" ]; then

      "${HOME}/.miniforge3/bin/conda" shell.zsh hook | tee "${ZSH_CACHE_DIR}/conda" >/dev/null

      sed -i 's/conda activate base/#conda activate base/g' "${ZSH_CACHE_DIR}/conda" #no activate the base conda env
    fi

    # shellcheck source=/dev/null
    source "${ZSH_CACHE_DIR}/conda"
  fi
}

__conda_bootstrap "$@"
