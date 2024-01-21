#!/usr/bin/env bash

function __ng_bootstrap () {
  if [ "$(mise which ng > /dev/null 2>&1)" ]; then
    local NG_COMMAND=$(mise which ng)

    source <(${NG_COMMAND} completion script)
  fi
}

__ng_bootstrap "$@"
