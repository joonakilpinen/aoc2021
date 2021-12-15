#!/usr/bin/env bash

INPUT=input.txt
POLYMER_TEMPLATE=$(head -1 $INPUT)
RULES=()
declare -gA LETTERS
declare -gA PAIRS
declare -A ROUND_PAIRS

while read -r line; do
  RULES+=( "${line// -> /,}" )
done <<<"$(tail +3 $INPUT)"

for ((i=1; i<=${#POLYMER_TEMPLATE}; i++)); do
  ((PAIRS[${POLYMER_TEMPLATE:i-1:1}${POLYMER_TEMPLATE:i:1}] += 1))
done

for ((i=0; i<${#POLYMER_TEMPLATE}; i++)); do
  ((LETTERS[${POLYMER_TEMPLATE:i:1}] += 1))
done

for _ in {1..40}; do
  declare -A ROUND_PAIRS
  for pair in "${!PAIRS[@]}"; do
    matching_rule=
    for item in "${RULES[@]}"; do
      IFS=, read -ra rule <<<"$item"
      if [ "${rule[0]}" = "$pair" ]; then
        matching_rule=1
        break
      fi
    done
    [ ! "$matching_rule" ] && continue
    newletter="${rule[1]}"
    ((ROUND_PAIRS[${pair:0:1}$newletter] += PAIRS[$pair]))
    ((ROUND_PAIRS[$newletter${pair:1:1}] += PAIRS[$pair]))
    ((LETTERS[$newletter] += PAIRS[$pair]))
  done
  unset PAIRS
  declare -A PAIRS
  for key in "${!ROUND_PAIRS[@]}"; do
    PAIRS[$key]="${ROUND_PAIRS[$key]}"
  done
  unset ROUND_PAIRS
done

LEAST_COMMON=
MOST_COMMON=
SUM=0
for key in "${!LETTERS[@]}"; do
  ((SUM+=LETTERS[$key]))
  echo "$key: ${LETTERS[$key]}"
  if [ ! "$LEAST_COMMON" ]; then
    LEAST_COMMON="$key"
  else
    if ((LETTERS[$LEAST_COMMON] > LETTERS[$key])); then
      LEAST_COMMON="$key"
    fi
  fi
  if [ ! "$MOST_COMMON" ]; then
    MOST_COMMON="$key"
  else
    if ((LETTERS[$MOST_COMMON] < LETTERS[$key])); then
      MOST_COMMON="$key"
    fi
  fi
done
echo "SUM: $SUM"
echo "MOST_COMMON: $MOST_COMMON - ${LETTERS[$MOST_COMMON]}"
echo "LEAST_COMMON: $LEAST_COMMON - ${LETTERS[$LEAST_COMMON]}"
echo $((LETTERS[$MOST_COMMON] - LETTERS[$LEAST_COMMON]))