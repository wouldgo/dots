#!/usr/bin/env zsh

_VENV_FILENAME=".virtualenv"

load-virtualenv() {
  if [[ -f "${_VENV_FILENAME}" ]]; then
    _VENV_VERSION="$(cat ${_VENV_FILENAME})"
    _VENV_PATH=".venv"
    _PYTHON_BINARY="$(command -v python${_VENV_VERSION})"

    if [[ ! -d "${_VENV_PATH}" ]]; then
      echo "Using binary ${_PYTHON_BINARY} to create virtual environment..."
      ${_PYTHON_BINARY} -m venv ${_VENV_PATH}
    fi

    # Check to see if already activated to avoid redundant activating
    if [[ "${VIRTUAL_ENV}" != "${_VENV_PATH}" ]]; then
      echo "Activating virtual environment..."
      source "${_VENV_PATH}"/bin/activate
    fi

    echo "Updating pip..."
    pip install --upgrade pip

    if [[ -f "requirements.txt" ]]; then
      echo "Installing dependecies from requirements.txt file..."
      pip install -r requirements.txt
    fi

    echo "All done."
  elif [ -n "${VIRTUAL_ENV}" ]; then

    echo "Deactivating current virtual environment..."
    deactivate
  fi
}
