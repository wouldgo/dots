#!/usr/bin/env zsh

function __packer_boostrap () {
  if [ "$(rtx which packer)" ]; then
    local PACKER_BIN=$(rtx which packer)

    complete -o nospace -C "${PACKER_BIN}" packer
  fi
}

__packer_boostrap "$@"
