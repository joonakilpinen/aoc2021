#!/usr/bin/env bash
MAX_X=0
MAX_Y=0
declare -A MATRIX
INPUT=input.txt

function read_coordinates() {
  while IFS=, read -ra line; do
    [ "${#line[@]}" = 0 ] && break
    [ "${line[0]}" -gt "$MAX_X" ] && MAX_X="${line[0]}"
    [ "${line[1]}" -gt "$MAX_Y" ] && MAX_Y="${line[1]}"
    MATRIX[${line[0]},${line[1]}]=1
  done < "$INPUT"
  for ((x=0; x<=MAX_X; x++)) do
    for ((y=0; y<=MAX_Y; y++)) do
      [ "${MATRIX[$x,$y]}" ] || MATRIX[$x,$y]=0
    done
  done
}

function horizontal_fold() {
  local fold_y=$1
  declare -A FOLD_MATRIX
  local fold_matrix_y=0
  for ((y=MAX_Y; y>fold_y; y--)); do
    for ((x=0; x<=MAX_X; x++)); do
      FOLD_MATRIX[$x,$fold_matrix_y]="${MATRIX[$x,$y]}"
    done
    ((fold_matrix_y++))
  done
  for ((x=0; x<=MAX_X; x++)); do
    for ((y=fold_y; y<MAX_Y; y++)); do
      unset "MATRIX[$x,$y]"
    done
  done
  MAX_Y=$((fold_y-1))
  TARGET_Y="$MAX_Y"
  for ((y=fold_matrix_y-1; y>=0; y--)); do
    for ((x=0; x<=MAX_X; x++)); do
      [ "${FOLD_MATRIX[$x,$y]}" = 1 ] && MATRIX[$x,$TARGET_Y]=1
    done
    ((TARGET_Y--))
  done
}

function vertical_fold() {
  local fold_x=$1
  declare -A FOLD_MATRIX
  local fold_matrix_x=0
  for ((x=MAX_X; x>fold_x; x--)); do
    for ((y=0; y<=MAX_Y; y++)); do
      FOLD_MATRIX[$fold_matrix_x,$y]="${MATRIX[$x,$y]}"
    done
    ((fold_matrix_x++))
  done
  for ((y=0; y<=MAX_Y; y++)); do
    for ((x=fold_x; x<MAX_X; x++)); do
      unset "MATRIX[$x,$y]"
    done
  done
  MAX_X=$((fold_x-1))
  TARGET_X="$MAX_X"
  for ((x=fold_matrix_x-1; x>=0; x--)); do
    for ((y=0; y<=MAX_Y; y++)); do
      [ "${FOLD_MATRIX[$x,$y]}" = 1 ] && MATRIX[$TARGET_X,$y]=1
    done
    ((TARGET_X--))
  done
}

function fold() {
  IFS='=' read -ra instruction <<<"$2"
  case "${instruction[0]}" in
  x) vertical_fold "${instruction[1]}";;
  y) horizontal_fold "${instruction[1]}";;
  esac
}

function read_instructions() {
  while read -r line; do
    if [[ "$line" =~ ^fold.* ]]; then
      eval "$line"
      break
    fi
  done < "$INPUT"
}

function print_matrix() {
  for ((y=0; y<=MAX_Y; y++)); do
    printf "["
    for ((x=0; x<=MAX_X; x++)); do
      printf "%s," "${MATRIX[$x,$y]}"
    done
    printf "]\n"
  done
  echo
}

function count_dots() {
  local counter=0
  for ((x=0; x<=MAX_X; x++)) do
    for ((y=0; y<=MAX_Y; y++)) do
      [ "${MATRIX[$x,$y]}" = 1 ] && ((counter++))
    done
  done
  echo $counter
}

read_coordinates
read_instructions
count_dots