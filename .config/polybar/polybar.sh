#!/bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar -c ~/.config/polybar/config example_left &
polybar -c ~/.config/polybar/config example_right & 
polybar -c ~/.config/polybar/config laptop &

echo "Bars launched..."
