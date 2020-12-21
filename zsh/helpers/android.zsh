#!/usr/bin/env zsh

export ANDROID_SDK_ROOT="${HOME}/android"
export ANDROID_HOME=${ANDROID_SDK_ROOT}

if [ -d ${ANDROID_SDK_ROOT} ]; then
  path=(
    "${ANDROID_SDK_ROOT}/platform-tools"
    "${ANDROID_SDK_ROOT}/apktool"
    "${ANDROID_SDK_ROOT}/emulator"
    $path)
  export PATH
fi
