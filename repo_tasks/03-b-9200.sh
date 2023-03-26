#!/bin/bash

find . -perm $(find /etc -type f -printf '%m %s \n' 2>/dev/null | sort -t' ' -k2 -n -r | head -n 1 | cut -d' ' -f1) -exec stat {} \;

