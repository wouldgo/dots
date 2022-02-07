#!/usr/bin/env zsh

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  path=(
    "/home/linuxbrew/.linuxbrew/bin"
    $path)
fi
