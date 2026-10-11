#!/usr/bin/env zsh

function __gh_bootstrap () {
  if (( $+commands[gh] )) && [ ! -f "${ZSH_COMPLETION_FOLDER}/_gh.zsh" ];then
    local GH_BIN=${commands[gh]}

    "${GH_BIN}" completion -s zsh | tee "${ZSH_COMPLETION_FOLDER}/_gh.zsh" >/dev/null
  fi
}

__gh_bootstrap "$@"
