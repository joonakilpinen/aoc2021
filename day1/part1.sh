#!/usr/bin/env bash

while read -r line; do
  [ "$line" -gt "$prev" ] && echo "$line"
  prev="$line"
done < input.txt | wc -l
