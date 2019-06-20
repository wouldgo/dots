#!/usr/bin/env bash

DOCKER_COMPOSE_VERSION=1.24.0 && \
curl -L https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose && \

echo "Elements put in completion folder"
