#!/usr/bin/env bash

INPUT=input.txt

declare -A INPUT_MATRIX
LOW_POINTS=()
MAX_I=0
MAX_J=0

function read_input() {
  while read -r line; do
    [ "$MAX_J" -lt "${#line}" ] && MAX_J="${#line}"
    for ((j=0; j<${#line}; j++)); do
      INPUT_MATRIX[$MAX_I,$j]="${line:j:1}"
    done
    ((MAX_I++))
  done < "$INPUT"
}

function print_matrix() {
  for ((i=0; i<MAX_I; i++)); do
    printf "["
    for ((j=0; j<MAX_J; j++)); do
      printf "%s," "${INPUT_MATRIX[$i,$j]}"
    done
    printf "]\n"
  done
}

function is_low_point() {
  local coordinates=(
    "$(($1-1)),$2"
    "$(($1+1)),$2"
    "$1,$(($2-1))"
    "$1,$(($2+1))"
  )

  local current="${INPUT_MATRIX[$1,$2]}"

  for coordinate in "${coordinates[@]}"; do
    if [ "${INPUT_MATRIX[$coordinate]}" ] && [ "$current" -ge "${INPUT_MATRIX[$coordinate]}" ]; then
      return 1
    fi
  done
}

function find_low_points() {
  for ((i=0; i<MAX_I; i++)); do
    for ((j=0; j<MAX_J; j++)); do
      is_low_point "$i" "$j" && LOW_POINTS+=( "$i,$j" )
    done
  done
}

function sum_risk_levels() {
  local sum=0
  for point in "${LOW_POINTS[@]}"; do
    ((sum += INPUT_MATRIX[$point] + 1))
  done
  echo "$sum"
}

read_input
# print_matrix
find_low_points
# echo "${LOW_POINTS[*]}"
sum_risk_levels