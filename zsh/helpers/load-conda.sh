#!/usr/bin/env bash

_REQUIREMENTS_FILE="requirements.txt"

_find_file_upwards() {
  local DIR
  local FOUND
  local TO_FIND

  DIR="${PWD}"
  FOUND='false'
  TO_FIND="${1}"

  while
    local RESULT

    RESULT=$(find "${DIR}"/ -maxdepth 1 -type f)
    while IFS= read -r A_FILE_INTO_FOLDER ; do
      local BASENAME

      BASENAME=$(basename "${A_FILE_INTO_FOLDER}");

      echo "ASDASDASD"
      if [[ "${TO_FIND}" == "${BASENAME}" ]]; then

        FOUND='true'
      fi
    done <<< "${RESULT}"

    [ "$DIR" != "/" ] && [ "${FOUND}" == 'false' ]
  do DIR=$(dirname "${DIR}"); done

  echo "${DIR}"
}

#_find_file_upwards ${_REQUIREMENTS_FILE}

#conda create -p /home/dario/git/nucleus/packages/99.99-functions/bench/.env --file requirements.txt
