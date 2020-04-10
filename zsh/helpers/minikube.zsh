#!/usr/bin/env zsh

if [ $commands[minikube] ]; then
  source <(minikube completion zsh)
fi
