#!/usr/bin/env bash

HORIZONTAL=0
DEPTH=0
AIM=0

function forward() {
  ((HORIZONTAL += $1))
  ((DEPTH += AIM * $1))
}

function down() {
  ((AIM += $1))
}

function up() {
  ((AIM -= $1))
}

eval "$(<input.txt)"

echo $((HORIZONTAL * DEPTH))