#!/usr/bin/env bash

EXIT_AFTER_ONE=0

function usage {
  echo "Usage: $(basename $0) [-e] GRID"
  echo "    -e    exit after one iteration"
  echo "    GRID  the grid file to play"
  exit 1
}

while getopts "e" OPT; do
  case "$OPT" in
    "e") EXIT_AFTER_ONE=1 ;;
      *) usage ;;
  esac
done

shift $((OPTIND-1))

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
  if [ $EXIT_AFTER_ONE -eq 1 ] && [ $cursor -eq 0 ] ; then
      exit
  fi
  __t1=$(gdate "+%s.%N")
  sleep $(echo "( 60 / $tempo ) - ( $__t1 - $__t0 )" | bc -l)
done
