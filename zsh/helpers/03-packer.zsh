#!/usr/bin/env zsh

function __packer_boostrap () {
  if [ "$(mise which packer)" ]; then
    local PACKER_BIN=$(mise which packer)

    complete -o nospace -C "${PACKER_BIN}" packer
  fi
}

__packer_boostrap "$@"
