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

function median() {
  readarray -t sorted < <(printf '%d\n' "${@}" | sort -n)
  count=${#sorted[@]}
  if (( count % 2 == 1 )); then
    echo "${sorted[$((count/2))]}"
  else
    echo "$(((sorted[count/2] + sorted[count/2+1])/2))"
  fi
}

TARGET=$(median "${CRABS[@]}")

for i in "${!FREQUENCIES[@]}"; do
  [ "$i" -gt "$TARGET" ] && ((CONSUMPTION += (i - TARGET) * FREQUENCIES[i]))
  [ "$i" -lt "$TARGET" ] && ((CONSUMPTION += (TARGET - i) * FREQUENCIES[i]))
done

echo "TARGET: $TARGET, CONSUMPTION: $CONSUMPTION"