#!/usr/bin/env zsh

export METEOR_ROOT="${HOME}/.meteor"

if [ -d ${METEOR_ROOT} ]; then
  path=(
    "${METEOR_ROOT}"
    $path)
  export PATH
fi
