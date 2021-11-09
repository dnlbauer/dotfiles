#!/bin/bash
EXTERNAL_OUTPUT="HDMI2"
INTERNAL_OUTPUT="eDP1"

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
  monitor_mode="CLONES"
# otherwise read the value from the file
else
  monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if [ $monitor_mode = "CLONES" ]; then
        monitor_mode="EXTERNAL"
        $HOME/.screenlayout/external.sh
elif [ $monitor_mode = "EXTERNAL" ]; then
        monitor_mode="CLONES"
        $HOME/.screenlayout/clone.sh
fi
echo "${monitor_mode}" > /tmp/monitor_mode.dat
