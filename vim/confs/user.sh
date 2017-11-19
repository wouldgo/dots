#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

git clone https://github.com/wouldgo/vimconf.git ${CURRENT_DIR}/../../vimconf && \
ln -s ${CURRENT_DIR}/../../vimconf/.vimrc ~/.vimrc
