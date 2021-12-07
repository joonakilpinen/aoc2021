#!/usr/bin/env bash

INPUT=input.txt
MAX_POSITION=-1
FREQUENCIES=()
CONSUMPTION=$(echo "$(printf "%u" -1) / 2" | bc )
TARGET=-1

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

function sum() {
  echo $(($1 * ($1 + 1) / 2))
}

for ((i=0; i<MAX_POSITION; i++)) do
  consumption=0
  for j in "${!FREQUENCIES[@]}"; do
    [ "$j" -gt "$i" ] && ((moves = j - i))
    [ "$j" -lt "$i" ] && ((moves = i - j))
    ((consumption += $(sum moves) * FREQUENCIES[j]))
  done
  if [ "$consumption" -lt "$CONSUMPTION" ]; then
    CONSUMPTION=$consumption
    TARGET=$i
  fi
done

echo "TARGET: $TARGET, CONSUMPTION: $CONSUMPTION"