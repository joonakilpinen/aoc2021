#!/usr/bin/env bash

ONES=()
ZEROS=()
GAMMA=()
EPSILON=()

function read_counts() {
  while read -r str; do
    i=0
    while [ $i -lt ${#str} ]; do
      [ -z "${ONES[i]}" ] && ONES[i]=0
      [ -z "${ZEROS[i]}" ] && ZEROS[i]=0
      if [ "${str:i:1}" == "1" ]; then
        ((ONES[i]++))
      else
        ((ZEROS[i]++))
      fi
      ((i++))
    done
  done < input.txt
}

function determine_gamma() {
  for i in "${!ONES[@]}"; do
    if [ "${ONES[i]}" -ge "${ZEROS[i]}" ]; then
      GAMMA[i]='1'
    else
      GAMMA[i]='0'
    fi
  done
}

function determine_epsilon() {
  for bit in "${GAMMA[@]}"; do
    EPSILON+=( "$(echo $bit | tr 01 10)" )
  done
}

function binary_array_to_decimal() {
  str=$(IFS=; echo "$*")
  echo $((2#$str))
}

read_counts
determine_gamma
determine_epsilon
DECIMAL_GAMMA=$(binary_array_to_decimal ${GAMMA[*]})
DECIMAL_EPSILON=$(binary_array_to_decimal ${EPSILON[*]})
echo "Part 1: $((DECIMAL_GAMMA * DECIMAL_EPSILON))"