#!/usr/bin/env bash

function __load_conda () {
  local _REQUIREMENTS_FILE
  local PATH_TO_PYTHON_ROOT
  local PATH_TO_CONDA_ENV
  local PATH_TO_REQUIREMENTS_FILE

  _REQUIREMENTS_FILE="requirements.txt"
  PATH_TO_PYTHON_ROOT=$(_find_file_upwards ${_REQUIREMENTS_FILE})

  if [ "${PATH_TO_PYTHON_ROOT}" != '/' ]; then
    PATH_TO_CONDA_ENV="${PATH_TO_PYTHON_ROOT}/.conda-env"
    PATH_TO_REQUIREMENTS_FILE="${PATH_TO_PYTHON_ROOT}/${_REQUIREMENTS_FILE}"

    local HAS_ELMS

    HAS_ELMS=$(find "${PATH_TO_CONDA_ENV}" -maxdepth 1 -type f)

    if [ ! -d "${PATH_TO_CONDA_ENV}" ] || [ -z "${HAS_ELMS+set}" ]; then
      echo "Creating env ${PATH_TO_CONDA_ENV} reflecting ${PATH_TO_REQUIREMENTS_FILE}"
      mkdir -p "${PATH_TO_CONDA_ENV}"
      conda create -p "${PATH_TO_CONDA_ENV}" --file "${PATH_TO_REQUIREMENTS_FILE}"
    fi

    conda activate "${PATH_TO_CONDA_ENV}"
    export __PYTHON_PATH=${PATH_TO_CONDA_ENV}
  else
    conda deactivate
    unset __PYTHON_PATH
  fi
}
