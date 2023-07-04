#!/bin/bash

: '
if [ $(id -u) -ne 0 ]; then
    echo "must be run as root"
    exit 1
fi
'

ROOT_TOTAL_RSS=$(ps -u  "root" -o rss= | \
                 xargs | sed 's/\s/+/g'| bc )


while read user home_dir; do
                CANDIDATES=""
                if [ ! -d ${home_dir} ]; then
                        CANDIDATES="${user}"
                elif [ $(stat -c "%U" ${home_dir}) != "${user}" ]; then
                        CANDIDATES="${user}"
                elif [ $(stat -c "%A" ${home_dir} | cut -c 3) != "w" ]; then
                        CANDIDATES="${user}"
                fi

                if [[ -n $CANDIDATES ]]; then
                        echo $CANDIDATES

                        TOTAL_RSS=$(ps -u  "${user}" -o rss= | awk '{TOTAL_RSS+=$1}END{print TOTAL_RSS}' )

                if [[ $TOTAL_RSS -gt $ROOT_TOTAL_RSS ]]; then
                    echo "pkill -U $user"
                fi
        fi

done < <(awk -F':' '$1 != "root" {print $1,$6}' /etc/passwd)
