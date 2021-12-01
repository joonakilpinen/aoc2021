#!/usr/bin/env bash

readarray -t input < input.txt
for i in "${!input[@]}"; do
  curr=$(IFS=+; subarr="(${input[@]:$((i-2)):3})"; echo $((${subarr[*]})))
  [ "$curr" -gt "$prev" ] && echo "$curr"
  prev=$curr
done | wc -l