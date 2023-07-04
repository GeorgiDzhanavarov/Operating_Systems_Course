#!/bin/bash

#if [[ $(id -u) -ne 0 ]]; then
#       echo "not a root"
#       exit 1
#fi

if [[ ${#} -ne 3 ]]; then
        echo "I am expecting 3 arguments"
        exit 2
fi

SRC=${1}
DST=${2}
STR=${3}


#check if dir is empty
if [[ ! -d $SRC || ! -d $DST ]]; then
        echo "I am expecting dir"
        exit 3
fi

if [ -n "$(find "$DST" -maxdepth 0 -type d ! -empty)" ]; then
    echo "DST directory must be empty."
    exit 1
fi


if [[ -z $STR ]]; then
        echo "I am expecting string"
        exit 4
fi

while read line; do
        : '
                example of logic
                SRC="/home/user/src"
                file="/home/user/src/dir1/file.txt"
                echo ${file#$SRC}  # Output: /dir1/file.txt
        '
        #get the directory structure of the file (parameter expansion)
        subdir=$(dirname "${line#$SRC}" )
        #echo "$subdir"

        mkdir -p "$DST/$subdir"

        cp $line "$DST/$subdir/"

done < <(find "$SRC" -type f -name "*$STR*" )
