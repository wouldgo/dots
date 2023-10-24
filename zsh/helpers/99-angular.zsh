#!/usr/bin/env bash

function __ng_bootstrap () {
  if [ "$(rtx which ng)" ]; then
    local NG_COMMAND=$(rtx which ng)

    source <(${NG_COMMAND} completion script)
  fi
}

__ng_bootstrap "$@"
