#!/usr/bin/env bash

function esp_idf () {
  if [ -f "/opt/esp-idf/export.sh" ]; then
    source /opt/esp-idf/export.sh
  fi
}
