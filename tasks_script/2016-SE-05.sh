#!/bin/bash

if [ $# -ne 2 ]; then
        echo "2 arguments are expected"
        exit 1
fi

if [ ! -f $1  -o ! -f $2 ]; then
        echo "the files should exist"
        exit 2
fi

occurrence_in_f1=$(grep -c "${1}" $1)
occurrence_in_f2=$(grep -c "${2}" $2)


if [ $occurrence_in_f1 -gt $occurrence_in_f2 ]; then
        cut -d'-' -f2- $1 | cut -c2- | sort > $1.songs
else
        cut -d'-' -f2- $2 | cut -c2- | sort > $2.songs
fi
