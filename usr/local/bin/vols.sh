doas /usr/bin/mixerctl -qn outputs.master | awk '{printf "%d",$1/2.55}'
