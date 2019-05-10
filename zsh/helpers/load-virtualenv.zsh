#!/usr/bin/env zsh

_VENV_FILENAME=".virtualenv"

load-virtualenv() {
  #I want the same env for the subfolders
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    local parent_virtual_env=$(dirname ${VIRTUAL_ENV})
    if [[ "${PWD##${parent_virtual_env}}" != "${PWD}" ]]; then

      return 0;
    fi
  fi

  #file is present
  if [[ -f "${_VENV_FILENAME}" ]]; then
    local virtual_env_version="$(cat ${_VENV_FILENAME})"
    local virtual_env_path=".venv"
    local python_binary="$(command -v python${virtual_env_version})"

    if [[ ! -d "${virtual_env_path}" ]]; then
      echo "Using binary ${python_binary} to create virtual environment..."
      ${python_binary} -m venv ${virtual_env_path}
    fi

    # Check to see if already activated to avoid redundant activating
    if [[ "${VIRTUAL_ENV}" != "${virtual_env_path}" ]]; then
      echo "Activating virtual environment..."
      source "${virtual_env_path}"/bin/activate
    fi

    echo "Updating pip..."
    pip install --upgrade pip

    if [[ -f "requirements.txt" ]]; then
      echo "Installing dependecies from requirements.txt file..."
      pip install -r requirements.txt
    fi

    echo "All done."
  elif [[ -n "${VIRTUAL_ENV}" ]]; then

    echo "Deactivating current virtual environment..."
    deactivate
  fi
}
