#!/bin/bash

file="cpumhz.log"

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

# output real-time cpu speed to file
watch -t -n1 "lscpu" \
      "| grep 'CPU MHz'" \
      "| sed 's/CPU MHz:\s\{3,\}//g'" \
      "| tee -a $file" > /dev/null &

read

exit
