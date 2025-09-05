#!/usr/bin/env zsh

function __goreleaser_bootstrap () {
  if [ "$(mise which -q goreleaser 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_goreleaser.zsh" ];then
    local  GORELEASER_BIN=$(mise which goreleaser)

    "${GORELEASER_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_goreleaser.zsh" >/dev/null
  fi
}

__goreleaser_bootstrap "$@"
