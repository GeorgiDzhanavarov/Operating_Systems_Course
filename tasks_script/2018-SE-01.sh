#!/bin/bash

LOGDIR="${1}"

friends=$(find $LOGDIR -mindepth 3 -maxdepth 3 -type d -printf "%f\n" | sort |uniq)

leaderboard=$(mktemp)
for f in $friends; do
        #echo $(find .  -type f -printf "%p\n"  | grep $f | xargs  wc -l | awk -v user=$f 'END{print user,$1}')
        echo $f $(find $LOGDIR  -mindepth 3 -type f -printf "%p\n"  | grep /$f/ | xargs cat | wc -l ) >> $leaderboard
done

cat $leaderboard
sort -k2 -nr $leaderboard | head | cut -d ' ' -f1


rm $leaderboard
