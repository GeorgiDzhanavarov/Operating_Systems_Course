#!/bin/bash

[ $(id -u) -eq 0 ] || exit 1

if [ -z "${CTRLSLOTS}" ]; then
    CTRLSLOTS=0
fi

if [[ $# -gt 1 ]]; then
        echo "I expect 0 or 1 parameter"
        exit 1
fi

function1() {
        echo "graph_title SSA drive temperatures"
        echo "graph_vlabel Celsius"
        echo "graph_category sensors"
        echo "graph_info This graph shows SSA drive temp"
        cat ssa-input.txt | awk '$1 == "Smart" {controller=$3}
                        $5 == "Slot" {slot=$6}\
                        $1 == "Array" {array=$2}\
                        $1 == "Unassigned" {array="UN"}
                        $1 == "physicaldrive" {
                                pd=$2;
                                print "SSA" slot controller array pd ".label", "SSA" slot,controller,array,pd "\n" "SSA" slot controller array pd ".type","GAUGE"
                        }
                '| sed 's/://;s/://'
}

function2() {
            cat ssa-input.txt | awk '$1 == "Smart" {controller=$3}
              $5 == "Slot" {slot=$6}\
              $1 == "Array" {array=$2}\
              $1 == "Unassigned" {array="UN"}
              $1 == "physicaldrive" {pd=$2}
              $1 == "Current" {
                temperature=$4
                print "SSA" slot controller array pd ".value",temperature
             }
          '| sed 's/://;s/://'
}


if [[ $1 == "autoconf" ]]; then
        echo "yes"
elif [[ $1 == "config" ]]; then
        for s in ${CTRLSLOTS}; do
       ${SSACLI} ctrl slot=${s} pd all show detail
    done | function1
elif [[ $# -eq 0 ]]; then
        for s in ${CTRLSLOTS}; do
                ${SSACLI} ctrl slot=${s} pd all show detail
        done | function2
else
        echo "invalid"
        exit 2
fi
