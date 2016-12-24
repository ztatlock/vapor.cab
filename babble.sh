#!/usr/bin/env bash

grid="$1"
width=100
tempo=100
cursor=0

# 1 iteration / beat
while true; do
  __t0=$(gdate "+%s.%N")

  __control=true
  while IFS='' read -r __line; do
    # ignore comments
    if [ "${__line:0:1}" = "#" ]; then
      continue
    fi

    if $__control; then
      if [ -z "$__line" ]; then
        __control=false
        echo "$grid: cursor = $cursor / tempo = $tempo / width = $width"
        continue
      else
        eval $__line
      fi
    else
      __c="${__line:$cursor:1}"
      case "$__c" in
        ".")
          continue
          ;;
        *)
          cmd="${__line:$width} \$$__c"
          eval echo "$cmd"
          eval $cmd &
          ;;
      esac
    fi
  done < "$grid"
  echo

  cursor=$(expr \( $cursor + 1 \) % $width)
  __t1=$(gdate "+%s.%N")
  sleep $(echo "( 60 / $tempo ) - ( $__t1 - $__t0 )" | bc -l)
done
