#!/bin/bash

cat file1 file2 file3 | sed 's/ //g' | egrep -o '.' | sort | uniq -c | sort -r -n -t ' ' -k 1
