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

while read -ra instruction; do
  case ${instruction[0]} in
  forward) forward instruction[1] ;;
  down) down instruction[1] ;;
  up) up instruction[1] ;;
  esac
done < input.txt

echo $((HORIZONTAL * DEPTH))