#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "expecting 2 arguments"
        exit 1
fi

if [[ ! -f $1 ]] && [[ ! -r $1 ]]; then
        echo "File1 doesn't exist or you have no read permissions"
        exit 2
fi

if [[ ! -f $2 ]] && [[ ! -w $2 ]]; then
        echo "File2 doesn't exist or you have no write permissions"
        exit 2
fi

if [[ -z $1 ]]; then
        echo "Nothing to read from"
        exit 3
fi

if [[ -s $2 ]]; then
        echo "File2 should be empty"
        exit 3
fi


while read line; do
        #echo "Line $line"
        sort -n $1 | egrep -m 1 "^[0-9]+,$line" >> $2
done < <( cut -d',' -f2- $1| sort| uniq)
