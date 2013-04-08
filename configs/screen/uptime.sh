#!/bin/bash

#################################################################################
# FILE: ~/.screen/uptime.sh
# AUTHOR: Collin "Ridayah" O'Connor <ridayah@gmail.com>
# VERSION: 1.0.0
# This gives us our current uptime.  Pretty simple, copy-pasted from who knows
# where.  I really need to find it again so I can credit the source. ;_;
#################################################################################

#let upSeconds="$(cat /proc/uptime) && echo ${temp%%.*})"
upSeconds=`cat /proc/uptime`;
upSeconds=${upSeconds%%.*};
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
if [ "${days}" -ne "0" ]
then
   echo -n "${days}d "
fi
echo "${hours}:${mins}"
