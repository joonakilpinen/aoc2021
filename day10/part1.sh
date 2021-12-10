#!/usr/bin/env bash

INPUT=input.txt
ERRORS=()

function is_closing() {
  [[ "$1" =~ }|]|\)|\> ]]
}

function get_opening() {
  case $1 in
  ')') echo '(';;
  ']') echo '[';;
  '}') echo '{';;
  '>') echo '<';;
  esac
}

function read_input() {
  while read -r line; do
    local stack=()
    for ((i=0; i<${#line}; i++)); do
      prev="${stack[-1]}"
      curr="${line:i:1}"
      if [ "$prev" ] && is_closing "$curr"; then
        if [ "$prev" = "$(get_opening $curr)" ]; then
          unset "stack[-1]"
          continue
        else
          ERRORS+=( "$curr" )
          break
        fi
      fi
      stack+=( "$curr" )
    done
  done < "$INPUT"
}

function syntax_error_score() {
  local score=0
  for char in "${ERRORS[@]}"; do
    case "$char" in
    ')') ((score += 3));;
    ']') ((score += 57));;
    '}') ((score += 1197));;
    '>') ((score += 25137));;
    esac
  done
  echo "$score"
}

read_input
syntax_error_score