#!/bin/bash

if [[ $# -ne 1 ]]; then
        exit 1
fi

if [[ ! $1 =~ ^[0-9]+$ ]]; then
        exit 2
fi

if [[ $(whoami) != root ]]; then
        exit 3
fi

USERS = $(ps -eo user= | sort | uniq)

for user in USERS; do
        process = $(ps -u $user -o pid=,rss= | sort -t' ' -k2 -n | awk '{ count += $2 } END {print count,$1}')

        pid = $(echo $process | cut -d' ' -f2)
        mem = $(echo $process | cut -d' ' -f1)

        if [[ $mem -gt $1 ]]; then
                #kill -TERM $pid
                sleep 2
                #kill -KILL $pid
        fi
done
