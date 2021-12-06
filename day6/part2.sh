#!/usr/bin/env bash

INPUT=input.txt
LANTERNFISH=()

function initialize_array() {
  for i in {0..8}; do
    LANTERNFISH+=( 0 )
  done
  while IFS=, read -ra line; do
    for fish in "${line[@]}"; do
      ((LANTERNFISH[fish]++))
    done
  done < "$INPUT"
}

function simulate_day() {
  LANTERNFISH=( "${LANTERNFISH[@]:1:8}" "${LANTERNFISH[0]}" )
  LANTERNFISH[6]=$((LANTERNFISH[6] + LANTERNFISH[8]))
}

function simulate_256_days() {
  for _ in {1..256}; do
    simulate_day
  done
}

function calculate_sum() {
  sum=0
  for i in "${!LANTERNFISH[@]}"; do
    ((sum += LANTERNFISH[i]))
  done
  echo "$sum"
}

initialize_array
simulate_256_days
echo "Part 2: $(calculate_sum)"