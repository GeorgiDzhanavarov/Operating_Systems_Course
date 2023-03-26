#!/bin/bash

cat ~/population.csv | awk -F',' 'BEGIN{i = 0} $(NF-1) == 2008 {i += $4} END{print i}'


cat ~/population.csv | awk -F',' 'BEGIN{i = 0} $(NF-1) == 2016 {i += $4} END{print i}'
