#!/usr/bin/env bash

function url_encode() {
  node -e '
    let input = "";
    process.stdin.on("data", c => input += c);
    process.stdin.on("end", () => process.stdout.write(encodeURIComponent(input)));
  '
}

function url_decode() {
  node -e '
    let input = "";
    process.stdin.on("data", c => input += c);
    process.stdin.on("end", () => process.stdout.write(decodeURIComponent(input)));
  '
}
