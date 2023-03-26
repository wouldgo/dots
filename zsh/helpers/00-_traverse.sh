#!/usr/bin/env bash

_find_file_upwards() {
  local DIR
  local FOUND
  local TO_FIND

  DIR="${PWD}"
  FOUND='false'
  TO_FIND="${1}"

  while
    while IFS= read -r A_FILE_INTO_FOLDER; do
      if [ "${TO_FIND}" == "$(basename "${A_FILE_INTO_FOLDER}")" ] ; then

        FOUND='true'
      fi
    done < <(find "${DIR}"/ -maxdepth 1 -type f)

    [ "$DIR" != "/" ] && [ "${FOUND}" == 'false' ]
  do DIR=$(dirname "${DIR}"); done

  echo "${DIR}"
}

#> /dev/null 2>&1
