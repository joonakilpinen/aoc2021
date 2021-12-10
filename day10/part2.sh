#!/usr/bin/env bash

INPUT=input.txt
SUMS=()

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
    error=
    for ((i=0; i<${#line}; i++)); do
      prev="${stack[-1]}"
      curr="${line:i:1}"
      if [ "$prev" ] && is_closing "$curr"; then
        if [ "$prev" = "$(get_opening $curr)" ]; then
          unset "stack[-1]"
          continue
        else
          error=1
          break
        fi
      fi
      stack+=( "$curr" )
    done
    [ "$error" ] && continue
    local linesum=0
    until [ "${#stack[@]}" = 0 ]; do
      ((linesum *= 5))
      case "${stack[-1]}" in
      '(') ((linesum += 1));;
      '[') ((linesum += 2));;
      '{') ((linesum += 3));;
      '<') ((linesum += 4));;
      esac
      unset "stack[-1]"
    done
    SUMS+=( "$linesum" )
  done < "$INPUT"
}

function middle() {
  readarray -t sorted < <(printf '%d\n' "${@}" | sort -n)
  count=${#sorted[@]}
  echo "${sorted[$((count/2))]}"
}

read_input
middle "${SUMS[@]}"