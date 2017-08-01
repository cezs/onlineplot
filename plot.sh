#!/bin/bash

set -e

# temporary file holding power draw data
log_pow=pow.log

function cleanup {
    sudo pkill -f read_from_40.py
    sudo pkill -f online_pow.sh
#    rm -f $log_pow
}

# remove previously generated log
if [ -e $log_pow ]; then
    rm -f $log_pow
else
    touch $log_pow
fi


# # kill all children processes on exit
# trap 'kill 0' EXIT

trap cleanup EXIT

sudo python ./read_from_40.py &
sleep 5
./onlineplot_pow.sh -f "pow.log" -n 30
