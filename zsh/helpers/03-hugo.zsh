#!/usr/bin/env zsh

function __hugo_bootstrap () {
  if [ "$(mise which -q hugo 2> /dev/null)" ] && [ ! -f "${ZSH_COMPLETION_FOLDER}/_hugo.zsh" ];then
    local  HUGO_BIN=$(mise which hugo)

    "${HUGO_BIN}" completion zsh | tee "${ZSH_COMPLETION_FOLDER}/_hugo.zsh" >/dev/null
  fi
}

__hugo_bootstrap "$@"
