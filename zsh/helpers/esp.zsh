#!/usr/bin/env zsh

export ESP_SDK_ROOT="${HOME}/esp"
export ESP_SDK_BIN="${ESP_SDK_ROOT}/bin"
export IDF_PATH="${ESP_SDK_ROOT}/esp-idf"

if [ -d "${ESP_SDK_BIN}" ]; then
  path=("${ESP_SDK_BIN}" $path)
  export PATH
fi
