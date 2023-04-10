#!/bin/bash

N=10

if [[ $1 = "-n" ]]; then
        shift
        N=$1
        [[ $N =~ ^[0-9]+$ ]] || { echo "arg is not num" >&2; exit 1; }
        shift
fi

temp=$(mktemp)

for file in "${@}"; do
        # tail -n $N "$file" | sed -E 's/(.{19}) (.*)/\1 '"$(echo $file | sed 's/\.log$//')"' \2/g' >> $temp
        tail -n $N "$file" | sed -E 's/(.{19}) (.*)/\1 '"$(basename $file .log)"' \2/g' >> $temp
done

sort $temp -k 1,2

rm $temp
