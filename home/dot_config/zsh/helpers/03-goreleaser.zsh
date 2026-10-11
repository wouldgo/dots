#!/usr/bin/env zsh

function __goreleaser_bootstrap () {
  if (( $+commands[goreleaser] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_goreleaser.zsh" ];then
    local  GORELEASER_BIN=${commands[goreleaser]}

    "${GORELEASER_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_goreleaser.zsh" >/dev/null
  fi
}

__goreleaser_bootstrap "$@"
