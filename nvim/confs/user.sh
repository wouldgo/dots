#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
NVIM_HOME="${HOME}/.config/nvim"

rm -Rfv "${NVIM_HOME}"
mkdir -p "${NVIM_HOME}"

ln -s "${CURRENT_DIR}/../lua" "${NVIM_HOME}/lua"
ln -s "${CURRENT_DIR}/../init.lua" "${NVIM_HOME}/init.lua"
