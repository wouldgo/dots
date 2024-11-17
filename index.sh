#!/usr/bin/env bash

function do_it () {
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

  # echo "Updating system" && \
  # if ! "${CURRENT_DIR}"/system/update-system.sh; then
  #   echo "Something went wrong" 2>&1
  # fi

  # echo "Installing dependencies" && \
  # if ! "${CURRENT_DIR}"/system/dependencies.sh; then
  #   echo "Something went wrong" 2>&1
  #   exit 1;
  # fi

  echo "Installing mandatory binaries" && \
  if ! "${CURRENT_DIR}/system/bins.sh"; then
    echo "Something went wrong" 2>&1
    exit 1;
  fi

  echo "Configuring zsh" && \
  if ! "${CURRENT_DIR}/zsh/index.sh"; then
    echo "Something went wrong" 2>&1
    exit 1;
  fi

  echo "Preparing mise config.toml" && \
  mkdir --parents "${HOME}/.config/mise" && \
  ln -sf "${CURRENT_DIR}/system/mise_config.toml" "${HOME}/.config/mise/config.toml"

  if ! "${CURRENT_DIR}/alacritty/index.sh"; then
    echo "Something went wrong" 2>&1
    exit 1;
  fi

  if ! "${CURRENT_DIR}/tmux/index.sh"; then
    echo "Something went wrong" 2>&1
    exit 1;
  fi
}

do_it "$@"
