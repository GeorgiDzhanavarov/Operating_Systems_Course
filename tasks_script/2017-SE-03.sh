#!/bin/bash

: '
if [ $(id -u) -ne 0 ]; then
    echo "must be run as root"
    exit 1
fi
'

for user in $( ps -e -o user=| sort | uniq); do
        read TOTAL_PS TOTAL_RSS MAX_RSS MAX_PID < <(ps -u  "${user}" -o rss=,pid= | sort -t ' ' -k1 -n|\
                awk '{TOTAL_RSS+=$1}END{print NR, TOTAL_RSS, $1 , $2}' )
        echo $TOTAL_PS $TOTAL_RSS

        if [[ $(echo $MAX_RSS| bc) -gt $(( 2 * ($TOTAL_RSS / $TOTAL_PS)  )) ]]; then
                echo "kill -KILL $MAX_PID"
        fi
done
