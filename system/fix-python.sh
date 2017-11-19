#!/usr/bin/env bash

! command -v python || {
  echo "python is present." 2>&1
  exit 0;
} && \

sudo update-alternatives --install \
  /usr/bin/python python \
  /usr/bin/python3 \
  1
