#!/usr/bin/env bash

_find_file_upwards() {
  local DIR="${PWD}"
  local TO_FIND="${1}"

  while [ "$DIR" != "/" ]; do
    if [ -f "${DIR}/${TO_FIND}" ]; then
      break
    fi
    DIR="${DIR%/*}"
    DIR="${DIR:-/}"
  done

  echo "$DIR"
}

#> /dev/null 2>&1
