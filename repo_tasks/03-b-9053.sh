#!/bin/bash

cat ~/population.csv | sed -E 's/^([^"][^,]*),/"\1",/g' | awk -F',' 'BEGIN {i = 0} i < $NF && $(NF-1) == 2016 {i = $NF; k = $0} END{print k}' | cut -d'"' -f2

cat ~/population.csv | sed -E 's/^([^"][^,]*),/"\1",/g' | awk -F',' 'BEGIN {i = 9999999999} i > $NF && $(NF-1) == 2016 {i = $NF; k = $0} END{print k}' | cut -d'"' -f2
