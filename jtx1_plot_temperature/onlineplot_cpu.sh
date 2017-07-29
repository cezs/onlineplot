#!/bin/bash

# temporary file holding gnuplot script
script=tmp.plt

# clean previously defined script
if [ -e $script ]; then
    rm -f $script
else
    touch $script
fi

set -e

# kill child processes on exit
trap 'kill 0' EXIT

# remove file on exit
trap "rm -f $script" EXIT

# parse options
while getopts ":f:s:e:n:" opt; do
    case $opt in
        # this script takes file containing a column of numeric data
        f) datafile="$OPTARG"
           ;;
        s) colstart="$OPTARG"
           ;;
        e) colend="$OPTARG"
           ;;
        n) numofsamples="$OPTARG"
           ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# set default column start to 0
if [ -z $colstart ]; then
    colstart=0
fi

# set default column end to 1
if [ -z $colend ]; then
    colend=1
fi

if [ -z $numofsamples ]; then
    # option 1: show cummulative
    echo "plot \"$datafile\" using $colstart:$colend with steps notitle" >> $script
    echo "pause 1" >> $script
    echo "reread" >> $script
else
    # option 2: show only last n samples
    echo "set autoscale xy" >> $script
    echo "plot \"< tail -n $numofsamples $datafile\" using $colstart:$colend with steps notitle" >> $script
    echo "pause 1" >> $script
    echo "reread" >> $script
fi

gnuplot $script

read

exit
