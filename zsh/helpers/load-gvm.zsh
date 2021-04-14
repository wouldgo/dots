#!/usr/bin/env zsh

_GVM_RC_FILE="go.mod"
_GO_SYSTEM_VERSION="$(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"

if [[ ! -n "${_GO_SYSTEM_VERSION}" ]]; then
  echo "Please install a default version for go with:
    gvm install go<version> -pb -b -B; gvm use go<version> --default"
fi

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

    gvm install "go${go_version}" -pb -b -B
    gvm use "go${go_version}"

    _GVMRC_FILE_PATH=$(realpath ${_GVM_RC_FILE})
  elif [[ -n "${_GVMRC_FILE_PATH}" ]]; then

    unset _GVMRC_FILE_PATH && \
    gvm use "go${_GO_SYSTEM_VERSION}"
  fi
}
