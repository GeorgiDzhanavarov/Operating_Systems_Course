#!/bin/bash

if [[ $# -ne 1 ]]; then
        echo "wrong number of params"
        exit 1
fi

if [[ ! -f $1 ]]; then
        echo "param is not file"
        exit 2
fi

temp=$(mktemp)
cat abcd | tail -n +2 | tr -s ' ' | cut -d' ' -f1,3 > $temp

while read device status; do

        line=$(grep -w "$device" $temp)
        if [[ -z $line ]]; then
                echo "$device does not exist"
                continue
        fi

        if [[ $status != "*enabled" && $status != "*disabled" ]]; then
                echo "$status is not valid"
                continue
        fi

        if [[ $status != $(echo $line | awk '{print $2}') ]]; then
                echo "$device" > abcd
        fi

done < <(cat $1 | sed -E 's/#.*//g' | sed '/^$/d')



rm $temp
