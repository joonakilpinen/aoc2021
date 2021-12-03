#!/usr/bin/env bash

determine_rating() {
  readarray -t input < input.txt
  index=0
  while [ "${#input[@]}" -gt 1 ]; do
    ones=()
    zeros=()
    for i in "${!input[@]}"; do
      str=${input[i]}
      [ -z "${ones[index]}" ] && ones[index]=0
      [ -z "${zeros[index]}" ] && zeros[index]=0
      if [ "${str:index:1}" == "1" ]; then
        ((ones[index]++))
      else
        ((zeros[index]++))
      fi
    done
    if eval "[ ${ones[index]} -$1 ${zeros[index]} ]"; then
      target=1
    else
      target=0
    fi
    for i in "${!input[@]}"; do
      [ "${#input[@]}" == 1 ] && break
      [ "$target" != "${input[i]:index:1}" ] && unset "input[$i]"
    done
    ((index++))
  done
  echo "${input[@]}"
}

function determine_oxygen_generator_rating() {
  determine_rating ge
}

function determine_co2_scrubber_rating() {
  determine_rating lt
}

BINARY_OGR=$(determine_oxygen_generator_rating)
BINARY_CSR=$(determine_co2_scrubber_rating)
OGR=$((2#$BINARY_OGR))
CSR=$((2#$BINARY_CSR))
echo "Part 2: $((OGR * CSR))"