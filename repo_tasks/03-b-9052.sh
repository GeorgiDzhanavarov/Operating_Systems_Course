#!/bin/bash

cat ~/population.csv | grep 'Bulgaria' | awk -F',' 'BEGIN{i = 0} $4 > i {i = $4; k = $3} END{print k}'
