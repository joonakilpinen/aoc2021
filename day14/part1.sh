#!/usr/bin/env bash

INPUT=input.txt
POLYMER_TEMPLATE=$(head -1 $INPUT)
RULES=()

function read_rules() {
  while read -r line; do
    RULES+=( "${line// -> /,}" )
  done <<<"$(tail +3 $INPUT)"
}

function do_that_funky_polymerization() {
  local input="$1"
  local matches
  for ruleindex in "${!RULES[@]}"; do
    local rule
    IFS=, read -ra rule <<<"${RULES[$ruleindex]}"
    local i
    for ((i=1; i<=${#input}; i++)); do
      if [ "${rule[0]}" = "${input:i-1:1}${input:i:1}" ]; then
        matches=1
        do_that_funky_polymerization "${input:0:i}"
        printf "%s" "${rule[1]}"
        do_that_funky_polymerization "${input:i:${#input}}"
        break
      fi
    done
    [ "$matches" ] && break
  done
  if [ ! "$matches" ]; then
    printf %s "$input"
  fi
}

read_rules

for _ in {1..10}; do
  POLYMER_TEMPLATE=$(do_that_funky_polymerization "$POLYMER_TEMPLATE")
done

declare -A FREQUENCIES
for ((i=0; i<${#POLYMER_TEMPLATE}; i++)); do
  ((FREQUENCIES[${POLYMER_TEMPLATE:i:1}]++))
done

LEAST_COMMON=
MOST_COMMON=

for key in "${!FREQUENCIES[@]}"; do
  ((FREQUENCIES[key]++))
  if [ ! "$LEAST_COMMON" ]; then
    LEAST_COMMON="$key"
  else
    if ((FREQUENCIES[$LEAST_COMMON] > FREQUENCIES[$key])); then
      LEAST_COMMON="$key"
    fi
  fi
  if [ ! "$MOST_COMMON" ]; then
    MOST_COMMON="$key"
  else
    if ((FREQUENCIES[$MOST_COMMON] < FREQUENCIES[$key])); then
      MOST_COMMON="$key"
    fi
  fi
done

echo $((FREQUENCIES[$MOST_COMMON] - FREQUENCIES[$LEAST_COMMON]))