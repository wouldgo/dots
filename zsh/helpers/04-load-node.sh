#!/usr/bin/env bash

function __load_node() {
  if [ "${IS_WSL}" == "NO" ]; then
    local _NVMRC_FILE
    local PATH_TO_NVMRC

    local _NODE_VERSION
    local _ACTUAL_NODE_VERSION

    _NVMRC_FILE=".nvmrc"
    PATH_TO_NVMRC=$(_find_file_upwards ${_NVMRC_FILE})

    if [ "${PATH_TO_NVMRC}" != "/" ]; then
      _NODE_VERSION="$(cat "${PATH_TO_NVMRC}/${_NVMRC_FILE}")"
      _ACTUAL_NODE_VERSION=$(rtx exec node -- node --version | sed 's/^v//')

      if [ "$_NODE_VERSION" != "$_ACTUAL_NODE_VERSION" ]; then

        rtx use "node@${_NODE_VERSION}"
      fi

      export __NODE_PATH=${PATH_TO_NVMRC}
      export __NODE_VERSION=${_NODE_VERSION}
    else
      unset __NODE_PATH
      unset __NODE_VERSION
    fi
  fi
}
