#!/bin/bash

find ~ -type f -printf '%T@ %f \n' | sort -t' ' -k 1 -n -r | cut -d' ' -f 2 | head -n 10 
