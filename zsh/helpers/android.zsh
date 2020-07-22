#!/usr/bin/env zsh

export ANDROID_SDK_ROOT='/home/dario/android'
export ANDROID_HOME=${ANDROID_SDK_ROOT}

path=(
  "${ANDROID_SDK_ROOT}/platform-tools"
  "${ANDROID_SDK_ROOT}/apktool"
  "${ANDROID_SDK_ROOT}/emulator"
  $path)
export PATH
