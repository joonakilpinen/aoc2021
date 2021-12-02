#!/usr/bin/env bash

HORIZONTAL=0
DEPTH=0
AIM=0

function forward() {
  HORIZONTAL=$((HORIZONTAL + $1))
  DEPTH=$((DEPTH + AIM * $1))
}

function down() {
  AIM=$((AIM + $1))
}

function up() {
  AIM=$((AIM - $1))
}

eval "$(cat input.txt)"

echo $((HORIZONTAL * DEPTH))