#!/usr/bin/env zsh

_VENV_FILENAME=".virtualenv"

load-virtualenv() {
  if [[ -f "${_VENV_FILENAME}" ]]; then
    _VENV_PATH=".venv"

    if [[ ! -d "${_VENV_PATH}" ]]; then
      python3 -m venv ${_VENV_PATH}
    fi

    # Check to see if already activated to avoid redundant activating
    if [[ "${VIRTUAL_ENV}" != "${_VENV_PATH}" ]]; then
      source "${_VENV_PATH}"/bin/activate
    fi

    if [[ -f "requirements.txt" ]]; then
      pip install -r requirements.txt
    fi
  elif [ -n "${VIRTUAL_ENV}" ]; then

    deactivate
  fi
}
