#!/bin/bash

if [[ $# -ne 1 ]]; then
        echo "wrong number of params"
        exit 1
fi

if [[ ! -d $1 ]]; then
        echo "$1 is not dir"
        exit 2
fi

temp=$(mktemp -d)

while read file; do

        hsh=$(sha256sum $file | cut -d' ' -f1)

        touch $temp/$hsh

        find $1 -name "$(basename $file)" -printf "%i %n\n" >> $temp/$hsh
done < <(find $1 -type f)

while read hFile; do

        out=$(cat "$temp"/$(basename $hFile) | awk '{if($2 == 1) one=+1; if($2 > 1) sec=+1} END{if(one > 1 && sec > 1) print "0" ; if(one == 0) print "1"; if(sec == 0) print "2"}')

        flag=$(echo "no" )

                while read iNode num; do

                        if [[ num -gt 1 ]]; then

                                find $1 -type f -inum $iNode | head -n 1
                        fi

                        if [[ $flag == "no" ]]; then

                                if [[ $out -eq 2 ]]; then
                                        flag=$(echo "yes")
                                        continue
                                fi
                        fi

                        find $1 -type f -inum $iNode

                done < <(cat $temp/$(basename $hFile) | sort | uniq )
done < <(find $temp -type f)

rm -r $temp
