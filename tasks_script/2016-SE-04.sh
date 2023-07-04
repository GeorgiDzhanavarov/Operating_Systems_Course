#!/bin/bash

if [ $# -ne 2 ]; then
        echo "two arguments are expected"
        exit 1
fi

if !( [[ $1 =~ ^[0-9]+$ ]] && [[ $2 =~ ^[0-9]+$ ]] ); then
        echo "the two arguments should be numbers"
        exit 2
fi

mkdir -p a b c

for i in $(find . -mindepth 1 -maxdepth 1 -type f); do
        SIZE=$(cat $i | wc -l)
        if [ $SIZE -lt $1 ]; then
                mv $i a/
        elif [ $SIZE -lt $2 ]; then
                mv $i b/
        else
                mv $i c/
        fi
done
