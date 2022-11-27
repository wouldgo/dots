#!/usr/bin/env bash

__boot_time() {
  for _ in $(seq 1 10); do
    /usr/bin/time -f "%e" "${SHELL}" -i -c exit;
  done
}
