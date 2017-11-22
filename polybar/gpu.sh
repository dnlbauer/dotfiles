#!/bin/bash

t_warn=50
t_crit=70

GPU=$(nvidia-smi -q | grep Gpu | awk '{print $3}')

if [ $GPU -gt $t_crit ]
then
    printf " %d%%" "$GPU"
    printf "\n %d%%" "$GPU"
    printf "\n#fb4934\n"
elif [ $GPU -gt $t_warn ]
then
    printf " %d%%" "$GPU"
    printf "\n %d%%" "$GPU"
    printf "\n#fabd2f\n"
else
    printf " %d%%" "$GPU"
    printf "\n %d%%" "$GPU"
fi
