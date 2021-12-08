#!/usr/bin/env bash

set -e

INPUT=input.txt
SUM=0

declare -A dictionary
INPUT_ARR=()

function find_by_length() {
  local retval
  local target_length=$1
  for num in "${!INPUT_ARR[@]}"; do
    if [ "${#INPUT_ARR[$num]}" == "$target_length" ]; then
      retval="${INPUT_ARR[$num]}"
      break
    fi
  done
  [ ! "$retval" ] && return 1
  echo "$retval"
}

function find_by_length_and_content() {
  local retval
  local target_length=$1
  shift
  local target_content=$1
  for num in "${!INPUT_ARR[@]}"; do
    [ "${#INPUT_ARR[$num]}" != "$target_length" ] && continue
    local missing_chars=0
    for ((i=0; i<${#target_content}; i++)); do
      [[ ${INPUT_ARR[$num]} =~ ${target_content:$i:1} ]] || ((missing_chars++))
    done
    [ "$missing_chars" -gt "0" ] && continue
    retval="${INPUT_ARR[$num]}"
    break
  done
  [ ! "$retval" ] && return 1
  echo "$retval"
}

function unique_chars() {
  local retval
  for ((i=0; i<${#1}; i++)); do
    [[ "$2" =~ ${1:$i:1} ]] || retval="$retval${1:$i:1}"
  done
  for ((i=0; i<${#2}; i++)); do
    [[ "$1" =~ ${2:$i:1} ]] || retval="$retval${2:$i:1}"
  done
  echo "$retval"
}

function unset_by_content() {
  local target
  for i in "${!INPUT_ARR[@]}"; do
    [ "$1" = "${INPUT_ARR[$i]}" ] && target=$i
  done
  [ ! "$target" ] && return 1
  unset "INPUT_ARR[$target]"
}

function create_dictionary() {
  INPUT_ARR=( "$@" )
  dictionary[8]=$(find_by_length 7)
  unset_by_content "${dictionary[8]}"
  dictionary[4]=$(find_by_length 4)
  unset_by_content "${dictionary[4]}"
  dictionary[7]=$(find_by_length 3)
  unset_by_content "${dictionary[7]}"
  dictionary[1]=$(find_by_length 2)
  unset_by_content "${dictionary[1]}"
  dictionary[9]=$(find_by_length_and_content 6 "${dictionary[4]}${dictionary[7]}")
  unset_by_content "${dictionary[9]}"
  dictionary[0]=$(find_by_length_and_content 6 "${dictionary[7]}")
  unset_by_content "${dictionary[0]}"
  dictionary[6]=$(find_by_length 6)
  unset_by_content "${dictionary[6]}"
  dictionary[3]=$(find_by_length_and_content 5 "${dictionary[7]}")
  unset_by_content "${dictionary[3]}"
  dictionary[2]=$(find_by_length_and_content 5 "$(unique_chars "${dictionary[6]}" "${dictionary[9]}")")
  unset_by_content "${dictionary[2]}"
  dictionary[5]=$(find_by_length 5)
}

function find_key_by_content() {
  for key in "${!dictionary[@]}"; do
    if [ "$(sort_string $1)" = "${dictionary[$key]}" ]; then
      echo "$key"
      break
    fi
  done
}

function sort_string() {
  echo "$1" | grep -o . | sort | tr -d "\n"
}

function sort_dictionary() {
  for key in "${!dictionary[@]}"; do
    dictionary[$key]=$(sort_string "${dictionary[$key]}")
  done
}

while IFS=' ' read -ra line; do
  input=( "${line[@]:0:10}" )
  create_dictionary "${input[@]}"
  sort_dictionary
  output=( "${line[@]:11:15}" )
  linesum=
  for num in "${output[@]}"; do
    linesum="$linesum$(find_key_by_content $num)"
  done
  ((SUM+=10#$linesum))
done < "$INPUT"

echo "$SUM"