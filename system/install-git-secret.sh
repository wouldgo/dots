#!/usr/bin/env bash

echo "deb https://dl.bintray.com/sobolevn/deb git-secret main" | \
  sudo tee -a /etc/apt/sources.list && \

wget -qO - https://api.bintray.com/users/sobolevn/keys/gpg/public.key | \
  sudo apt-key add - && \

sudo apt update && \
sudo apt install -y git-secret && \
sudo apt autoremove