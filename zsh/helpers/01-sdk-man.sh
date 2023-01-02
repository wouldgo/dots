#!/usr/bin/env bash

function __sdkman_bootstrap () {
  local SDKMAN_DIR
  SDKMAN_DIR="${HOME}/.sdkman"

  if [ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]; then

    # shellcheck source=/dev/null
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi

  unset SDKMAN_DIR
}

__sdkman_bootstrap "$@"
