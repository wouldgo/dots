#!/usr/bin/env bash

export VIRTUAL_ENV_DISABLE_PROMPT=1

function __load_python () {
  local _REQUIREMENTS_FILE
  local _PYRC_VERSION_FILE
  local _DOT_VENV_DIRECTORY

  local PATH_TO_PYRC_FILE
  local PATH_TO_REQUIREMENTS_FILE

  local _PYTHON_VERSION
  local _ACTUAL_PYTHON_VERSION

  local PYTHON_EXEC
  local PIP_EXEC

  _REQUIREMENTS_FILE="requirements.txt"
  _PYRC_VERSION_FILE=".pyrc"
  _DOT_VENV_DIRECTORY=".venv"

  PATH_TO_PYRC_FILE=$(_find_file_upwards ${_PYRC_VERSION_FILE})
  PATH_TO_REQUIREMENTS_FILE=$(_find_file_upwards ${_REQUIREMENTS_FILE})

  if [ "${PATH_TO_PYRC_FILE}" != '/' ]; then
    _PYTHON_VERSION="$(cat "${PATH_TO_PYRC_FILE}/${_PYRC_VERSION_FILE}")"
    _ACTUAL_PYTHON_VERSION=$(rtx exec python -- python --version | sed 's/^Python\ //')

    if [ "$_PYTHON_VERSION" != "$_ACTUAL_PYTHON_VERSION" ]; then
      rtx use "python@${_PYTHON_VERSION}"
    fi

    PYTHON_EXEC=$(rtx which python)
    PIP_EXEC=$(rtx which pip)

    if [ ! -d "${PATH_TO_PYRC_FILE}/${_DOT_VENV_DIRECTORY}" ];  then

      mkdir -p "${PATH_TO_PYRC_FILE}/${_DOT_VENV_DIRECTORY}";
      "${PYTHON_EXEC}" -m venv "${PATH_TO_PYRC_FILE}/${_DOT_VENV_DIRECTORY}";
    fi

    # shellcheck source=/dev/null
    source "${PATH_TO_PYRC_FILE}/.venv/bin/activate";

    if [ "${PATH_TO_REQUIREMENTS_FILE}" != '/' ]; then

      echo "INSTALL";
      "${PIP_EXEC}" install -r "${PATH_TO_REQUIREMENTS_FILE}/${_REQUIREMENTS_FILE}";
    fi

    export __PYTHON_PATH=${PATH_TO_PYRC_FILE}
    export __PYTHON_VERSION=${_PYTHON_VERSION}
  elif
    # shellcheck disable=SC2236
    [ ! -z ${VIRTUAL_ENV+x} ]; then

    deactivate
    unset __PYTHON_PATH
    unset __PYTHON_VERSION
  else
    unset __PYTHON_PATH
    unset __PYTHON_VERSION
  fi
}
