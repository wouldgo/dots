#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && ! command -v gcc || {
  echo "your're not root" 2>&1
  exit 0;
} && \

apt update && \
apt install -y git \
  gcc \
  make \
  autoconf \
  yodl \
  libncursesw5-dev \
  checkinstall \
  ttf-ancient-fonts
