#!/usr/bin/env zsh

load-virtualenv() {
  if [[ -f ".venv" ]]; then
    _VENV_NAME=$(cat .venv)
    _VENV_PATH="${VENV_HOME}/${_VENV_NAME}"

    if [[ ! -d "${_VENV_PATH}" ]]; then
      python3 -m venv ${_VENV_PATH}
    fi

    # Check to see if already activated to avoid redundant activating
    if [[ "${VIRTUAL_ENV}" != "${_VENV_PATH}" ]]; then
      source "${_VENV_PATH}"/bin/activate
    fi
  elif [ -n "${VIRTUAL_ENV}" ]; then

    deactivate
  fi
}
