#!/bin/bash

declare -a sensor=("AO-therm" "CPU-therm" "GPU-therm" "PLL-therm" "PMIC-Die" "Tdiode_tegra" "Tboard_tegra" "thermal-fan-est.46")

# temporary file holding gnuplot script
script=tmp.plt

# remove previously generated script
if [ -e $script ]; then
    rm -f $script
else
    touch $script
fi

set -e

# kill all children processes on exit
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

echo "set datafile separator ','" >> $script
if [ -z $numofsamples ]; then
    # option 1: show cummulative
    echo "set key autotitle columnhead" >> $script
    arraylen=${#sensor[@]}
    pt2=$(echo "plot '$datafile' u 1 with steps title '${sensor[1]}', ")
    for (( i=1; i<${arraylen}+1; i++ ));
    do
        pt1=$(echo "'$datafile' u $i with steps title '${sensor[$i]}', ")
        pt2=$my2$my1
    done
    echo "${pt2::-2}" >> $script
    echo "pause 1" >> $script
    echo "reread" >> $script
else
    # option 2: show only last n samples
    echo "set autoscale xy" >> $script

#     # Non-portable version
#     arraylen=${#sensor[@]}
#     pt2=$(echo "plot \"< tail -n $numofsamples $datafile\" \
# u 0:1 with steps title '${sensor[1]}', ")
#     for (( i=2; i<${arraylen}+1; i++ ));
#     do
#         pt1=$(echo "\"< tail -n $numofsamples $datafile\" \
# u 0:$i with steps title '${sensor[$i]}', ")
#         pt2=$pt2$pt1
#     done
#     echo "${pt2::-2}" >> $script

    # Portable version
    echo "plot \"< tail -n $numofsamples $datafile\" \
u 0:1 with steps title '${sensor[0]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:2 with steps title '${sensor[1]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:3 with steps title '${sensor[2]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:4 with steps title '${sensor[3]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:6 with steps title '${sensor[5]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:7 with steps title '${sensor[6]}', \
\"< tail -n $numofsamples $datafile\" \
u 0:8 with steps title '${sensor[7]}'" >> $script
    echo "pause 1" >> $script
    echo "reread" >> $script
fi

gnuplot $script

read

exit
