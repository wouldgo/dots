#!/usr/bin/env zsh

function __meteor_bootstrap () {
  local METEOR_ROOT
  METEOR_ROOT="${HOME}/.meteor"

  if [ -d ${METEOR_ROOT} ]; then
    path=(
      "${METEOR_ROOT}"
      $path)
    export PATH
  fi
}

__meteor_bootstrap "$@"
