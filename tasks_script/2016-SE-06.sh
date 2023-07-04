#!/bin/bash

if [ $# -ne 1 ]; then
        echo "we need 1 argument"
        exit 1
fi

if ! [ -f $1 ]; then
        echo "the first argument should be file"
        exit 2
fi

cut -d'-' -f2- $1 | cut -c2- | awk '{print NR"." $0}' | sort -t'.' -k2
