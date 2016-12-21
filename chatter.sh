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
    per=$(echo "( 60 / $tempo )" | bc -l)

    case "${line:$col:1}" in
      "x")
        cmd=$(echo ${line:$ncols} \
              | sed -e "s/\$PER/$per/g")
        echo " $cmd"
        $cmd &
        ;;
    esac
  done < "$score"

  col=$(expr \( $col + 1 \) % $ncols)
  t1=$(gdate "+%s.%N")
  sleep $(echo "$per - ( $t1 - $t0 )" | bc -l)
done
