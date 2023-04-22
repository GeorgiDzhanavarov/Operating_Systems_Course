#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "params are not 2"
        exit 1
fi

if [[ ! $1 =~ ^[0-9]+$ ]]; then
        echo "param is not number"
        exit 2
fi

if [[ ! $2 =~ ^[0-9]+$ ]]; then
        echo "param is not number"
        exit 2
fi

mkdir ./a 2>/dev/null
mkdir ./b 2>/dev/null
mkdir ./c 2>/dev/null

while read file; do

        if [[ $(cat $file | wc -l | bc) -lt $1 ]]; then
                mv $file ./a/
                continue
        fi

        if [[ $(cat $file | wc -l | bc) -le $2 ]]; then
                mv $file ./b/
                continue
        fi

        mv $file ./c/

done < <(find . -type f)
