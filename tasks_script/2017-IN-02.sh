#!/bin/bash

if [[ ${#} -ne 1 ]]; then
        echo "invalid number of arguments"
        exit 1
fi

: '
if [[ $(id -u) -ne 0 ]]; then
        echo "not a root"
        exit 2
fi
'

num_ps_of_foo=$( ps -u "${1}" -o user= | wc -l )

for user in $(ps -e -o user= | sort| uniq ); do

        if [[ $(ps -u "${user}" -o user= | wc -l) -gt ${num_ps_of_foo} ]]; then
                echo ${user}
        fi

done

counter=0
time=0
while IFS=':' read HH MM SS; do
        ((counter++))
        ((time+=$(expr ${HH} \* 3600 + ${MM} \* 60 + ${SS})))
done < <(ps -e -o time=)

avg_time=$(expr ${time} / ${counter} ) # don't forget to add space

echo $avg_time

while read time pid; do
        time_in_sec=$(echo ${time}| awk -F':' '{print $1*3600+$2*60+$3}')
        if [[ $(echo ${time_in_sec} | bc) -gt $(( 2 * avg_time)) ]]; then
                echo "kill $pid"
                # kill -KILL ${pid}
        fi
done< <(ps -u "${1}" -o time=,pid=)
