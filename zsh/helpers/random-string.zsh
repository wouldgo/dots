#!/usr/bin/env zsh

random-string() {
  local length

  length=${1:-64}
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${length} | head -n 1
}
