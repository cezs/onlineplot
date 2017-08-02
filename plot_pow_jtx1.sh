#!/bin/bash

set -e

# temporary file holding power draw data
log_pow=pow.log

function cleanup {
    sudo pkill -f read_from_40.py
    sudo pkill -f online_pow.sh
}

# remove previously generated log
if [ -e $log_pow ]; then
    rm -f $log_pow
else
    touch $log_pow
fi

trap cleanup EXIT

sudo python ./scan_pow_jtx1.py &
sleep 5
./onlineplot_pow_jtx1.sh -f "pow.log" -n 30
