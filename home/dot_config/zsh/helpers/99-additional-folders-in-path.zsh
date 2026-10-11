#!/usr/bin/env zsh

function __additional_folders_in_path_bootstrap () {
  local RHT_FOLDER="${HOME}/git/rht/dev"

  if [ -d ${RHT_FOLDER} ]; then
    path=(
      "${RHT_FOLDER}"
      $path)
    export PATH
  fi
}

__additional_folders_in_path_bootstrap "$@"
