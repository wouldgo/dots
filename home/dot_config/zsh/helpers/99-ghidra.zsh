#!/usr/bin/env bash

function __ghidra_bootstrap () {
  if [ -d "${HOME}/software/ghidra_12.1.4_PUBLIC" ]; then
    export GHIDRA_INSTALL_DIR="${HOME}"/software/ghidra_12.1.4_PUBLIC
  fi
}

__ghidra_bootstrap "$@"
