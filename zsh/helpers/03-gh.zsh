#!/usr/bin/env zsh

function __gh_bootstrap () {
  if [ "$(mise which -q gh 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_gh.zsh" ];then
    local GH_BIN=$(mise which gh)

    "${GH_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_gh.zsh" >/dev/null
  fi
}

__gh_bootstrap "$@"
