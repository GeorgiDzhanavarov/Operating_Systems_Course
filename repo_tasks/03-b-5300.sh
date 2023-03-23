#!/bin/bash


cat /etc/passwd | cut -d':' -f5 | cut -d',' -f1 | sed 's/ //g' | egrep -o '.'  | sort | uniq -c | wc -l 
