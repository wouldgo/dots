#!/usr/bin/env bash

__boot_time() {
  TIMES="${1:-3}"
  for _ in $(seq 1 "${TIMES}"); do
    /usr/bin/time -f "%e" "${SHELL}" -i -c exit;
  done
}
