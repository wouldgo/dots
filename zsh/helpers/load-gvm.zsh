#!/usr/bin/env zsh

_GVM_RC_FILE=".gvmrc"
_GO_SYSTEM_VERSION="${gvm_go_name}"

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
    local go_version="$(cat ${_GVM_RC_FILE})"

    gvm install ${go_version} --prefer-binary
    if [ "${_GO_SYSTEM_VERSION}" != "${go_version}" ]; then

      gvm use ${go_version}
    fi

    _GVMRC_FILE_PATH=$(realpath ${_GVM_RC_FILE})
  elif [[ -n "${_GVMRC_FILE_PATH}" ]]; then

    echo "Reverting to global go settings" && \
    unset _GVMRC_FILE_PATH && \
    gvm use ${_GO_SYSTEM_VERSION}
  fi
}
