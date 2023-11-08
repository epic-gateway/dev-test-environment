#!/bin/bash

brname=$USER-epic0

# validate parameter
if [ "X$1" = "X" ]; then
    echo "$0"
    echo "Needs a parameter: either \"up\" or \"destroy\""
    exit 1
fi

# check that brctl is installed
which brctl > /dev/null 2>&1
if [ $? = 1 ] ; then
    echo "brctl not found - please install"
    exit 2
fi

if [ "$1" = "up" ]; then

    brctl show "$brname" 2> /dev/null

    if [ $? = 1 ]; then
        echo "creating $brname"
        sudo brctl addbr "$brname"
        sudo ip link set "$brname" up
    fi
fi

if [ "$1" = "destroy" ]; then
    if brctl show "$brname" > /dev/null 2>&1; then
        echo "destroying $brname"
        sudo ip link set "$brname" down
        sudo brctl delbr "$brname"
    fi
fi
