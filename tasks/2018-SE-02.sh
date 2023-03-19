#!/bin/bash

find ~pesho -type f -printf '%n %T@ %i \n' 2>/dev/null | grep -v '^1' | sort -n -k 2 | tail -n 1 | cut -d ' ' -f 3 
