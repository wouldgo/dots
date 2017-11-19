#!/usr/bin/env bash

[[ $EUID -eq 0 ]] || {
  echo "your're not root" 2>&1
  exit 0;
} && \

apt update && \
apt install -y libevent-dev \
  libncurses5-dev \
  pkg-config
