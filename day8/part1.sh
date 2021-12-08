#!/usr/bin/env bash

INPUT=input.txt

declare -A UNIQUE_LENGTHS=(
  [2]=1
  [3]=7
  [4]=4
  [7]=8
)

SUM=0

while IFS=' ' read -ra line; do
  output=( "${line[@]:11:15}" )
  for num in "${output[@]}"; do
    [ "${UNIQUE_LENGTHS[${#num}]}" ] && ((SUM++))
  done
done < "$INPUT"

echo "$SUM"