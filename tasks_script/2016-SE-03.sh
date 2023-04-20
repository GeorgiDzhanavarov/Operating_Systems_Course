#!/bin/bash

if [[ $(whoami) != root ]]; then
        echo "not root"
        exit 1
fi

while read line; do

        user=$(echo $line | cut -d':' -f1)
        home=$(echo $line | cut -d':' -f6)

        if [[ ! -d $home ]]; then
                echo "Not dir"
                continue
        fi

        perm=$(stat -c '%a' $home | cut -c -1)

        if [[ ! $perm =~ [2367] ]]; then
                echo "$user does not have perm"
        fi

done < <(cat /etc/passwd) 2>/dev/null
