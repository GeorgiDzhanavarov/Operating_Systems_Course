#!/bin/bash 


egrep "(.*:){3}$(cat /etc/passwd | sort -t ':' -n -k 3 | awk -F':' 'NR == 201 {print $4}'):" /etc/passwd | cut -c 2- | sort -t ':' -n -k 1 | cut -d ':' -f 5,6 | sed 
-E 's/([^,]*),(.*):(.*)/\1:\3/'
