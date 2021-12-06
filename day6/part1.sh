#!/usr/bin/env bash

INPUT=input.txt
LANTERNFISH=()

function initialize_array() {
  while IFS=, read -ra line; do
    for fish in "${line[@]}"; do
      LANTERNFISH+=( "$fish" )
    done
  done < "$INPUT"
}

function simulate_day() {
  for i in "${!LANTERNFISH[@]}"; do
    ((LANTERNFISH[i]--))
    if [ "${LANTERNFISH[i]}" -lt 0 ]; then
      LANTERNFISH[i]=6
      LANTERNFISH+=( 8 )
    fi
  done
}

function simulate_80_days() {
  for i in {1..80}; do
    simulate_day
  done
}

initialize_array
simulate_80_days
echo "Part 1: ${#LANTERNFISH[@]}"