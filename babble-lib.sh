function evalI {
  echo "$@" | bc
}

function evalF {
  echo "$@" | bc -l
}

function set_tempo_beat {
  tempo=$(evalF "60 / $1")
}

function dur {
  evalF "(60 / $tempo) / (1 / $1)"
}

# synth argument order matches sox
# expand FRQ to allow chords
function synth {
  DUR="$1"
  WAV="$2"
  FRQ=$3
  VOL="$4"
  /usr/local/bin/play -q -n synth "$DUR" "$WAV" $FRQ vol "$VOL"
}

# helpers put freq last for convenience
function sin { synth "$1" sine     "$3" "$2"; }
function sqr { synth "$1" square   "$3" "$2"; }
function tri { synth "$1" triangle "$3" "$2"; }
function saw { synth "$1" sawtooth "$3" "$2"; }
function plk { synth "$1" pluck    "$3" "$2"; }
function nos { synth "$1" noise    "$3" "$2"; }

function org {
  case $3 in
    Am7)
      sin $1 $2 "sin %-12 sin %-9 sin %-5 sin %-2 fade h 0.1"
      ;;
    c2)
      sin $1 $2 "sin %-12 sin %-9 sin %-7 sin %-2 fade h 0.1"
      ;;
    c3)
      sin $1 $2 "sin %-12 sin %-9 sin %-7 sin %-5 fade h 0.1"
      ;;
  esac
}

function apply {
  ${@:$(($#))} ${@:1:(($#-1))}
}
