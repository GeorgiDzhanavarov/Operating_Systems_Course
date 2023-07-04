#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "Expecting 2 arguments"
        exit 1
fi


if [[ ! -d $1 ]]; then
        echo "Expecting directory"
        exit 2
fi

: '
if [[ -d $2 ]]; then
        echo "directory should not exist "
        exit 2
fi
'


mkdir -p $2/images

while read -rd $'\0' path; do
        #echo $path
        file=$(basename "${path}")
        sum=$(sha256sum "$path"| cut -c 1-16)
        title=$( echo "$file" | sed -E 's/\([^()]+\)//g'| tr -s ' ' )

        date=$(stat -c "%y" "$path" | cut -d ' ' -f1)
        cp $path $2/images/$sum.jpg

        if ! echo "${file}" | egrep -q '\(.*\)'; then
        album=misc
    else
        album="$(basename "$path" .jpg | sed 's/.*\((.*)\)/\1/' | tr -s ' ')"
    fi

    echo $album
        #ln -s $2/images/$sum.jpg $2/by-date/$date/by-album/$album/by-title/$title
        #ln -s $2/images/$sum.jpg $2/by-date/$date/by-title/$title
        #ln -s $2/images/$sum.jpg $2/by-album/$album/by-date/$date/by-title/$title
        #ln -s $2/images/$sum.jpg $2/by-album/$album/by-title/$title
        #ln -s $2/images/$sum.jpg $2/by-title/$title
done < <(find $1 -type f -name "*.jpg"  -print0)
