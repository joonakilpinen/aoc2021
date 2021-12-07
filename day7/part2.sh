#!/usr/bin/env bash

INPUT=input.txt
MAX_POSITION=-1
FREQUENCIES=()
CONSUMPTION=0

IFS=, read -ra CRABS < "$INPUT"
for crab in "${CRABS[@]}"; do
  [ "$crab" -gt "$MAX_POSITION" ] && MAX_POSITION="$crab"
done

for ((i=0; i<MAX_POSITION; i++)) do
  FREQUENCIES+=( 0 )
done

for crab in "${CRABS[@]}"; do
  ((FREQUENCIES[crab]++))
done

function mean() {
  sum=0
  for crab in "${CRABS[@]}"; do
    ((sum+=crab))
  done
  echo $((sum / ${#CRABS[@]}))
}

TARGET="$(mean "${CRABS[@]}")"

function sum() {
  echo $(($1 * ($1 + 1) / 2))
}

for i in "${!FREQUENCIES[@]}"; do
  [ "$i" -gt "$TARGET" ] && ((moves = i - TARGET))
  [ "$i" -lt "$TARGET" ] && ((moves = TARGET - i))
  ((CONSUMPTION += $(sum moves) * FREQUENCIES[i]))
done

echo "TARGET: $TARGET, CONSUMPTION: $CONSUMPTION"