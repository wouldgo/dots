#!/usr/bin/env bash

random-string() {
  local length

  length=${1:-64}
  < /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w "${length}" | head -n 1
}
