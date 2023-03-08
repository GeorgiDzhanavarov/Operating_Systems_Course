#!bin/bash

find . -maxdepth 1 -type f -printf "%n %f\n" | sort -rn | head -n 5 | cut -d " " -f 2 
