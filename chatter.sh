#!/usr/bin/env bash

score="$1"
tempo="60"
ncols=16
col=0

# 1 iteration / beat
while true; do
  t0=$(gdate "+%s.%N")

  control=true
  while IFS='' read -r line; do
    if $control; then
      tempo=$(echo "$line" | cut -d ' ' -f 1)
      ncols=$(echo "$line" | cut -d ' ' -f 2)
      control=false
      echo "$col: t = $tempo, n = $ncols"
    fi

    case "${line:$col:1}" in
      "x")
        echo " ${line:$ncols}"
        ${line:$ncols} &
        ;;
    esac
  done < "$score"

  col=$(expr \( $col + 1 \) % $ncols)
  t1=$(gdate "+%s.%N")
  sleep $(echo "( 60 / $tempo ) - ( $t1 - $t0 )" | bc -l)
done
