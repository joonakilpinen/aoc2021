#!/usr/bin/env bash

MAX_X=0
MAX_Y=0
declare -A MATRIX
OVERLAPS=0
INPUT="$(sed 's/ -> /,/' < input.txt)"

function find_max_coordinates() {
  while IFS=, read -ra line; do
    [ "${line[0]}" -gt "$MAX_X" ] && MAX_X="${line[0]}"
    [ "${line[2]}" -gt "$MAX_X" ] && MAX_X="${line[2]}"
    [ "${line[1]}" -gt "$MAX_Y" ] && MAX_Y="${line[1]}"
    [ "${line[3]}" -gt "$MAX_Y" ] && MAX_Y="${line[3]}"
  done <<<"$INPUT"
}

function fill_matrix_with_zeros() {
  for ((x=0; x<=MAX_X; x++)) do
    for ((y=0; y<=MAX_Y; y++)) do
      MATRIX[$x,$y]=0
    done
  done
}

function process_segments() {
  while IFS=, read -ra line; do
    x1=${line[0]}
    x2=${line[2]}
    y1=${line[1]}
    y2=${line[3]}
    move=true
    [ "$x1" -gt "$x2" ] && move="$move; ((x--))"
    [ "$x2" -gt "$x1" ] && move="$move; ((x++))"
    [ "$y1" -gt "$y2" ] && move="$move; ((y--))"
    [ "$y2" -gt "$y1" ] && move="$move; ((y++))"
    x="$x1"
    y="$y1"
    while [ "$x" != "$x2" ] || [ "$y" != "$y2" ]; do
      ((MATRIX[$x,$y]++))
      eval "$move"
    done
    ((MATRIX[$x,$y]++))
  done <<<"$INPUT"
}

function find_overlaps() {
  for ((x=0; x<=MAX_X; x++)) do
    for ((y=0; y<=MAX_Y; y++)) do
      [ "${MATRIX[$x,$y]}" -ge 2 ] && ((OVERLAPS++))
    done
  done
}

function print_matrix() {
  for ((y=0; y<=MAX_Y; y++)) do
    for ((x=0; x<=MAX_X; x++)) do
      printf "%s" "${MATRIX[$x,$y]}"
    done
    echo
  done
}

find_max_coordinates
fill_matrix_with_zeros
process_segments
find_overlaps
# print_matrix
echo "Part 2: $OVERLAPS"