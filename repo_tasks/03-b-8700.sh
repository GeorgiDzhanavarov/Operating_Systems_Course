#!/bin/bash

cat /etc/passwd | cut -d':' -f4 | sort | uniq -c | sort -t' ' -k 1 -n -r | head -n 5 

cat /etc/passwd | cut -d':' -f4 | sort | uniq -c | sort -t' ' -k 1 -n -r | head -n 5 | tr -s ' ' | cut -d' ' -f3 | xargs getent group | cut -d':' -f1
 
