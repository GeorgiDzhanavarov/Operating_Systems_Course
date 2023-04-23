#!/bin/bash

if [[ $# -ne 1 ]]; then
        echo "wrong number of params"
        exit 1
fi

if [[ ! -d $1 ]]; then
        echo "$1 is not dir"
        exit 2
fi

touch "$1/foo.conf"
echo > $1/foo.conf

while read file; do

        ./$1/validate.sh $file &>/dev/null

        if [[ $ -eq 0 ]]; then
                cat file >> foo.conf

        name=$(echo $file | sed -E 's/(.*)\.cfg^/\1')

        if [[ -z $(grep $name $1/foo.pwd) ]]; then
                pass=$(pwgen 10 1)
                echo "$name:$pass"
                hashpass=$(mkpasswd $pass)
                echo -e "$name:$hashpass\n" >> $1/foo.pwd
        fi
        continue
        fi

        ./$1/validate.sh $file &>/dev/null

        if [[ $ -eq 1 ]]; then
                ./$1/validate.sh $file | awk -v FILE=$file '{printf "%s:%s\n", FILE, $0}' 1>&2
        fi


done < <(find $1/cfg -type f -name "*.cfg")
