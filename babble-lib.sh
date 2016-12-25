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

function synth {
  /usr/local/bin/play -q -n synth $1 $2 $3 vol $4
}

function sin { synth $1 sine     $3 $2; }
function sqr { synth $1 square   $3 $2; }
function tri { synth $1 triangle $3 $2; }
function saw { synth $1 sawtooth $3 $2; }
function plk { synth $1 pluck    $3 $2; }
function nos { synth $1 noise    $3 $2; }

function apply {
  ${@:$(($#))} ${@:1:(($#-1))}
}
