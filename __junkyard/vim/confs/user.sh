#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

ln -s "${CURRENT_DIR}/../.vimrc" "${HOME}/.vimrc"
