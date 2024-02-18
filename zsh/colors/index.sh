#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

wget -O "${CURRENT_DIR}/dracula-dircolors" https://raw.githubusercontent.com/dracula/dircolors/main/.dircolors
