#!/usr/bin/env bash

tmux set -gu default-shell && \
tmux set -gu set-titles && \
tmux set -gu repeat-time && \
tmux set -gu escape-time && \
tmux set -gu history-limit && \
tmux set -gu display-time && \
tmux set -gu default-terminal && \
tmux set -gu mouse
