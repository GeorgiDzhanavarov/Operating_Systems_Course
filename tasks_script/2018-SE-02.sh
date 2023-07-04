#!/bin/bash

# proverka za empty dir

if [ "$#" -ne 2 ]; then
        echo 'Expectign 2 arguments'
        exit 1
fi


if [ ! -f "$1" ]; then
        echo "Not a regular file: $minutes" 1>&2
        exit 1
fi

if [ ! -d "$2" ]; then
        echo "Not a directory: $outdir" 1>&2
        exit 1
fi

if [[ -z $(find $2 -maxdepth 0 -empty) ]]; then
        echo "directory is not empty"
fi

touch $2/dict.txt

counter=1

while read name; do
        echo "$name;$counter" >> $2/dict.txt
        touch $2/$counter.txt
        cat $1| egrep "^$name\s?(\(.*\))?:" >> $2/$counter.txt
        ((counter += 1))
done < <(cat $1| sed -E 's/^(([a-zA-Z\-]+) ([a-zA-Z\-]+))\s?(\(.*\))?:.*$/\1/' | sort | uniq)
