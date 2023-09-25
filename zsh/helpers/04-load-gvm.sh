#!/usr/bin/env bash

#gvm install go<version> -pb -b; gvm use go<version> --default"
function __load_gvm() {
  local _GOMOD_FILE
  local _GO_SYSTEM_VERSION
  local PATH_TO_GO_ROOT
  local _GO_VERSION

  _GOMOD_FILE="go.mod"
  _GO_SYSTEM_VERSION="$(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"
  PATH_TO_GO_ROOT=$(_find_file_upwards ${_GOMOD_FILE})

  if [ "${PATH_TO_GO_ROOT}" != "/" ]; then
    _GO_VERSION="$(grep -oP '^go\W+(.*)$' "${PATH_TO_GO_ROOT}/${_GOMOD_FILE}" | sed -e 's/go //')"

    gvm install "go${_GO_VERSION}" -pb -b
    gvm use "go${_GO_VERSION}"
    export __GO_PATH=${PATH_TO_GO_ROOT}
  else
    unset __GO_PATH
    #gvm use "go${_GO_SYSTEM_VERSION}"
  fi
}
