#!/usr/bin/env bash

_find_file_upwards() {
  local DIR="${PWD}"
  local TO_FIND="${1}"

  while [ "$DIR" != "/" ]; do
    if find "$DIR" -maxdepth 1 -type f -exec basename {} \; | grep -q "^${TO_FIND}$"; then
      break
    fi
    DIR=$(dirname "$DIR")
  done

  echo "$DIR"
}

#> /dev/null 2>&1
