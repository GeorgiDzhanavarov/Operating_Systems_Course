#!/bin/bash

while IFS=':' read user home; do
        if [[ -d ${home} ]]; then
                find "${home}" -type f -printf "${user} %T@ %p\n" 2>/dev/null
        fi
done < <(cut -d: -f1,6 /etc/passwd)| sort -t' ' -k2 -rn | head -1 | cut -d' ' -f1,3)
