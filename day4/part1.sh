#!/usr/bin/env bash

INPUT=input.txt
WINNER=
NUMBER=
UNMARKED_SUM=0

function write_bingo_tickets() {
  player=0
  while read -ra line; do
    if [ -z "${line[*]}" ]; then
      ((player++))
      row=0
    else
      for i in "${!line[@]}"; do
        mkdir -p "tickets/$player/$row/$i/${line[i]}"
      done
      ((row++))
    fi
  done <<<"$(tail +3 $INPUT)"
}

function mark_bingo_number() {
  NUMBER=$1
  find tickets -mindepth 4 -maxdepth 4 -type d -name "$1" -exec touch '{}/x' \;
}

function check_for_winning_rows() {
  local player
  local column
  local count
  while read -r line; do
    IFS=/ read -ra match_array <<<"$line"
    if [ "$player" != "${match_array[0]}" ]; then
      player=${match_array[0]}
      row=
    fi
    if [ "$row" != "${match_array[1]}" ]; then
      row=${match_array[1]}
      count=0
    fi
    ((count++))
    if [ "$count" == "5" ]; then
      WINNER="$player"
      return 0
    fi
  done <<<"$(find tickets -mindepth 5 -maxdepth 5 -type f | sed 's|tickets/\(.*\)/.*/x|\1|' | sort -n -t '/' -k1 -k2 -k3)"
  return 1
}

function check_for_winning_columns() {
  local player
  local column
  local count
  while read -r line; do
    IFS=/ read -ra match_array <<<"$line"
    if [ "$player" != "${match_array[0]}" ]; then
      player=${match_array[0]}
      column=
    fi
    if [ "$column" != "${match_array[2]}" ]; then
      column=${match_array[2]}
      count=0
    fi
    ((count++))
    if [ "$count" == "5" ]; then
      WINNER="$player"
      return 0
    fi
  done <<<"$(find tickets -mindepth 5 -maxdepth 5 -type f | sed 's|tickets/\(.*\)/x|\1|' | sort -n -t '/' -k1 -k3 -k2)"
  return 1
}

function check_for_winners() {
  check_for_winning_rows || check_for_winning_columns
}

function calculate_unmarked() {
  while read -r line; do
    ((UNMARKED_SUM += line))
  done <<<"$(find tickets/$WINNER -type d -empty | sed 's|.*/||')"
}

function do_the_bingo_thingy() {
  write_bingo_tickets
  IFS=, read -ra numbers <<<"$(head -1 $INPUT)"
  for number in "${numbers[@]}"; do
    mark_bingo_number "$number"
    check_for_winners && break
  done
  calculate_unmarked
}

rm -rf tickets
do_the_bingo_thingy
echo "Part 1 - Winner: $WINNER, Number: $NUMBER, Unmarked sum: $UNMARKED_SUM, Solution: $((NUMBER * UNMARKED_SUM))"