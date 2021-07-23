#!/bin/bash

brname=$USER-epic0

if [ $1 = "up" ]; then

    brctl show $brname 

    if [ $? = 1 ]; then
        echo "creating $brname"
        sudo brctl addbr $brname
        sudo ip link set $brname up
    fi
fi

if [ $1 = "destroy" ]; then

    brctl show $brname 

    if [ $? = 0 ]; then
        echo "deleting $brname"
        sudo ip link set $brname down
        sudo brctl delbr $brname

    fi
fi
