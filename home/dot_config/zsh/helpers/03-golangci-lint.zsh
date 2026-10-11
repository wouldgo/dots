#!/usr/bin/env zsh

function __golangci_lint_bootstrap () {
  if (( $+commands[golangci-lint] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_golangci-lint.zsh" ];then
    local GOLANGCI_LINT_BIN=${commands[golangci-lint]}

    "${GOLANGCI_LINT_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_golangci-lint.zsh" >/dev/null
  fi
}

__golangci_lint_bootstrap "$@"
