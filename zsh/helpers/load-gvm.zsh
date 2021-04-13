#!/usr/bin/env zsh

export GVM_DIR="${HOME}/.gvm"

if [ -d ${GVM_DIR} ]; then
  path=(
    "${GVM_DIR}"
    $path)
  export PATH
fi

_GVM_RC_FILE="go.mod"
_GO_SYSTEM_VERSION="tip"

load-gvmrc() {
  #I want the same env for the subfolders
  if [[ -n "${_GVMRC_FILE_PATH}" ]]; then
    local parent_gvmrc_path=$(dirname ${_GVMRC_FILE_PATH})
    if [[ "${PWD##${parent_gvmrc_path}}" != "${PWD}" ]]; then

      return 0;
    fi
  fi

  #file is present
  if [[ -f "${_GVM_RC_FILE}" ]]; then
    local go_version="$(grep -oP '^go\W+(.*)$' ${_GVM_RC_FILE} | sed -e 's/go //')"

    eval "$(gvm ${go_version})"

    _GVMRC_FILE_PATH=$(realpath ${_GVM_RC_FILE})
  elif [[ -n "${_GVMRC_FILE_PATH}" ]]; then

    unset _GVMRC_FILE_PATH && \
    eval "$(gvm ${_GO_SYSTEM_VERSION})"
  fi
}
