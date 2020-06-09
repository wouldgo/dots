#!/usr/bin/env zsh

if [ -d "/home/dario/istio-1.6.1/bin" ]; then
  path=("/home/dario/istio-1.6.1/bin" $path)
  export PATH
fi
