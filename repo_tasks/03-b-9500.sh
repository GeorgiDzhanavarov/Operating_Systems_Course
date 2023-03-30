#!/bin/bash

cat ~/ssa-input.txt | awk -F' ' '
  BEGIN {x = "";y = "";z = "";w = ""}
  {if($0 ~ /Array [A-Z]/) {x = $NF}
  if($0 ~ /physicaldrive .*/) {y = $NF}
  if($0 ~ /Current Temperature/) {z = $NF}
  if($0 ~ /Maximum Temperature/) {w = $NF; printf("%s-%s %d %d \n",x,y,z,w)}
}'
