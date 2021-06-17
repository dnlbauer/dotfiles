#!/bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
    NUM_DEVICES=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l);
    if [[ $NUM_DEVICES -lt 2 ]]; then
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            MONITOR=$m polybar --reload laptop &
        done  
    else
        # primary screen
        for m in $(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1); do
            MONITOR=$m polybar --reload laptop &
        done
        # other screens
        for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
            MONITOR=$m polybar --reload laptop_secondary &
        done
    fi
else
  polybar --reload laptop &
fi
# polybar -c ~/.config/polybar/config laptop &
# polybar -c ~/.config/polybar/config laptop_extern &

echo "Bars launched..."
