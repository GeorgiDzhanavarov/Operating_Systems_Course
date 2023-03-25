#!/bin/bash

find /usr -name '*.sh' -exec head -n 1 {} \; | egrep '^(#!)' | sort | uniq -c | sort -t' ' -k1 -n -r | head -n 1
