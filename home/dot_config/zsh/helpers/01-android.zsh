#!/usr/bin/env zsh

function __android_bootstrap () {
  export ANDROID_SDK_ROOT="${HOME}/android"
  export ANDROID_HOME=${ANDROID_SDK_ROOT}

  if [ -d ${ANDROID_SDK_ROOT} ]; then
    path=(
      "${ANDROID_SDK_ROOT}/platform-tools"
      "${ANDROID_SDK_ROOT}/apktool"
      "${ANDROID_SDK_ROOT}/emulator"
      "${ANDROID_SDK_ROOT}/tools"
      "${ANDROID_SDK_ROOT}/tools/bin"
      $path)
    export PATH
  fi
}

__android_bootstrap "$@"
