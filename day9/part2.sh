#!/usr/bin/env bash

INPUT=input.txt

declare -A INPUT_MATRIX
declare -A BASINS

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

function calculate_basin() {
  local origin="${2:-$1}"
  local current="${INPUT_MATRIX[$1]}"
  unset "INPUT_MATRIX[$1]"
  ((BASINS["$origin"]++))
  IFS=, read -ra current_coordinates <<<"$1"
  local coordinates_to_check=(
    "$((current_coordinates[0]-1)),${current_coordinates[1]}"
    "$((current_coordinates[0]+1)),${current_coordinates[1]}"
    "${current_coordinates[0]},$((current_coordinates[1]-1))"
    "${current_coordinates[0]},$((current_coordinates[1]+1))"
  )
  for coordinate in "${coordinates_to_check[@]}"; do
    local target="${INPUT_MATRIX[$coordinate]}"
    if [ "$target" ] && [ "$current" -le "$target" ] && [ "$target" -lt 9 ]; then
      calculate_basin "$coordinate" "$origin"
    fi
  done
}

function bazinga() {
  for point in "${LOW_POINTS[@]}"; do
    calculate_basin "$point"
  done
  local answer=1
  for num in $(printf "%s\n" "${BASINS[@]}" | sort -n -r | head -3); do
    ((answer*=num))
  done
  echo "$answer"
}

read_input
find_low_points
bazinga