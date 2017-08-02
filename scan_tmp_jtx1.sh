#!/bin/bash

file="temperature.log"

set -e

# kill child processes on exit
trap 'kill 0' EXIT

# remove file on exit
trap "rm -f $file" EXIT

# clean previously gathered data
if [ -e $file ]; then
    rm $file
else
    touch $file
fi

cat /sys/devices/virtual/thermal/thermal_zone*/type | sed ':a;N;$!ba;s/\n/,/g' > temperatury.log
watch -t -n 1 "cat /sys/devices/virtual/thermal/thermal_zone*/temp" \
      "| tr '\n' ','" \
      "| sed -e 's/,/\n/8'" \
      "| tee -a $file" > /dev/null &

read

exit
