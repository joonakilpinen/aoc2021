#!/usr/bin/env bash

HORIZONTAL=0
DEPTH=0

while read -ra instruction; do
  case ${instruction[0]} in
  forward) ((HORIZONTAL += instruction[1])) ;;
  down) ((DEPTH += instruction[1])) ;;
  up) ((DEPTH -= instruction[1])) ;;
  esac
done < input.txt

echo $((HORIZONTAL * DEPTH))