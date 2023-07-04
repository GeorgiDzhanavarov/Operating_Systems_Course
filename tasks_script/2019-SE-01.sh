#!/bin/bash



f=$(mktemp)

while read line; do
        echo $line| egrep "^[-]?[0-9]+$" >> $f
done

#1
: "

max_value=$(sed -E 's/-?([0-9]+)/\1/' $f| sort -n | tail -1)

echo "Max uniq value"
egrep "$max_value" $f| uniq


rm $f
"

#2
max_value=""
lowest_number=""
while read number; do
        value=$( echo $number| sed -E 's/-?([0-9]+)/\1/' |\
                egrep -o .| awk '{sum+=$1}END{print sum}')
        if [[ $value > $max_value ]]; then
                max_value=$value #no need to put $ when assigning a value
                lowest_number=$number
        fi
done < <(sort -n $f)

echo "Lowest number"
echo $lowest_number
