#!/usr/bin/env bash

function __ng_bootstrap () {
  if [ "$(mise which -q ng 2> /dev/null)" ]; then
    local NG_COMMAND=$(mise which ng)

    source <(${NG_COMMAND} completion script)
  fi
}

__ng_bootstrap "$@"
