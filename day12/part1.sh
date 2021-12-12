#!/usr/bin/env bash

INPUT=input.txt
declare -A NODES

function read_nodes() {
  IFS=- read -ra link <<<"$1"
  local node_links=${NODES[${link[0]}]}
  if [ "$node_links" ]; then
    node_links="$node_links "
  fi
  node_links="$node_links${link[1]}"
  NODES[${link[0]}]="$node_links"

  node_links=${NODES[${link[1]}]}
  if [ "$node_links" ]; then
    node_links="$node_links "
  fi
  node_links="$node_links${link[0]}"
  NODES[${link[1]}]="$node_links"
}

function read_input() {
  while read -r line; do
    read_nodes "$line"
  done < "$INPUT"
}

function find_routes() {
  local node="$1"
  shift
  local visited=( "$@" )
  if [ "$node" = "end" ]; then
    echo "${visited[*]} $node"
    return 0
  fi
  if [[ "${visited[*]}" =~ $node ]]; then
    [[ "$node" =~ [A-Z] ]] || return 0
  fi
  IFS=' ' read -ra links <<<"${NODES[$node]}"
  for link in "${links[@]}"; do
    find_routes "$link" "${visited[@]}" "$node"
  done
}

read_input

find_routes "start" | wc -l