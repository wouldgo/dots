#!/usr/bin/env bash

function fzf () {
  local FZF_HIDDEN_FOLDER
  FZF_HIDDEN_FOLDER="${HOME}/.fzf"

  if [ -e "${FZF_HIDDEN_FOLDER}" ]; then

    echo "fzf already installed" 2>&1
    return
  fi

  git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_HIDDEN_FOLDER}" && \
  "${FZF_HIDDEN_FOLDER}/install" \
    --key-bindings \
    --completion \
    --no-update-rc \
    --no-bash \
    --no-fish
}

function nvim () {
  local NVIM_HIDDEN_FOLDER
  NVIM_HIDDEN_FOLDER="${HOME}/.nvim"

  if [ -e "${NVIM_HIDDEN_FOLDER}" ]; then

    echo "nvim already installed" 2>&1
    return
  fi

  mkdir -p "${NVIM_HIDDEN_FOLDER}" && \
  (cd "${NVIM_HIDDEN_FOLDER}"; curl -LOk https://github.com/neovim/neovim/releases/latest/download/nvim.appimage) && \
  chmod u+x "${NVIM_HIDDEN_FOLDER}/nvim.appimage" && \
  mv "${NVIM_HIDDEN_FOLDER}/nvim.appimage" "${NVIM_HIDDEN_FOLDER}/nvim"
}

function ripgrep () {
  cargo install ripgrep
}

function do_it () {
  fzf;
  nvim;
#  ripgrep;
}

do_it "$@"
