#!/usr/bin/env bash

INPUT=input.txt
declare -A ENERGY_MATRIX
FLASHES=0
MAX_I=0
MAX_J=0

function read_input() {
  while read -r line; do
    [ "$MAX_J" -lt "${#line}" ] && MAX_J="${#line}"
    for ((j=0; j<${#line}; j++)); do
      ENERGY_MATRIX[$MAX_I,$j]="${line:j:1}"
    done
    ((MAX_I++))
  done < "$INPUT"
}

function print_matrix() {
  for ((i=0; i<MAX_I; i++)); do
    printf "["
    for ((j=0; j<MAX_J; j++)); do
      printf "%s," "${ENERGY_MATRIX[$i,$j]}"
    done
    printf "]\n"
  done
}

function neighbors() {
  local neighbors=(
    "$1,$(($2-1))"
    "$1,$(($2+1))"
    "$(($1-1)),$2"
    "$(($1+1)),$2"
    "$(($1-1)),$(($2-1))"
    "$(($1+1)),$(($2+1))"
    "$(($1-1)),$(($2+1))"
    "$(($1+1)),$(($2-1))"
  )
  echo "${neighbors[*]}"
}

function increment_or_flash() {
  if [ ! "${ENERGY_MATRIX[$1,$2]}" ] || [ "${FLASH_MATRIX[$1,$2]}" ]; then
    return 0
  else
    ((ENERGY_MATRIX[$1,$2]++))
  fi
  if ((ENERGY_MATRIX[$1,$2] > 9)); then
    ((FLASHES++))
    ENERGY_MATRIX[$1,$2]=0
    FLASH_MATRIX[$1,$2]=1
    IFS=' ' read -ra neighbors <<<"$(neighbors "$1" "$2")"
    for neighbor in "${neighbors[@]}"; do
      IFS=, read -ra coordinates <<<"$neighbor"
      increment_or_flash "${coordinates[0]}" "${coordinates[1]}"
    done
  fi
}

function step() {
  declare -gA FLASH_MATRIX
  for ((i=0; i<MAX_I; i++)); do
    for ((j=0; j<MAX_J; j++)); do
      increment_or_flash "$i" "$j"
    done
  done
  unset "FLASH_MATRIX"
}

read_input

function simultaneous_flash() {
  for ((i=0; i<MAX_I; i++)); do
    for ((j=0; j<MAX_J; j++)); do
      [ "${ENERGY_MATRIX[$i,$j]}" = '0' ] || return 1
    done
  done
}

STEP=0
until simultaneous_flash; do
  ((STEP++))
  step
done
echo "$STEP"
