#!/usr/bin/env bash

function __load_go() {
  local _GOMOD_FILE
  local PATH_TO_GO_ROOT

  local _GO_VERSION
  local _ACTUAL_GO_VERSION

  _GOMOD_FILE="go.mod"
  PATH_TO_GO_ROOT=$(_find_file_upwards ${_GOMOD_FILE})

  if [ "${PATH_TO_GO_ROOT}" != "/" ]; then
    _GO_VERSION="$(grep -oP '^go\W+(.*)$' "${PATH_TO_GO_ROOT}/${_GOMOD_FILE}" | sed -e 's/go //')"
    _ACTUAL_GO_VERSION="$(rtx exec go -- go version | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"

    if [ "$_GO_VERSION" != "$_ACTUAL_GO_VERSION" ]; then

      rtx use "go@${_GO_VERSION}"
    fi
    export __GO_PATH=${PATH_TO_GO_ROOT}
    export __GO_VERSION=${_GO_VERSION}
  else
    unset __GO_PATH
    unset __GO_VERSION
  fi
}