#!/usr/bin/env zsh

function __packer_boostrap () {
  if [ "$(mise which -q packer 2> /dev/null)" ]; then
    local PACKER_BIN=$(mise which packer)

    complete -o nospace -C "${PACKER_BIN}" packer
  fi
}

__packer_boostrap "$@"
