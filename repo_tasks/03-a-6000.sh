#!/bin/bash

 cat ~/emp.data | awk 'BEGIN {i = 0} {i += 1} END {print(i)}'
 
 cat ~/emp.data | awk 'NR == 3 {print $0}'
 
 cat ~/emp.data | awk '{print $NF}'

 cat ~/emp.data | awk 'END {print $NF}' 
 
 cat ~/emp.data | awk 'NF > 4 {print $0}'
 
 cat ~/emp.data | awk '$NF > 4 {print $0}'
 
 cat ~/emp.data | awk 'BEGIN {i = 0} {i += NF} END{print i}'
 
 cat ~/emp.data | awk 'BEGIN {i =0} $1=="Beth" {i +=1 } END {i}'
 
 cat ~/emp.data | awk 'BEGIN {i = -1} $3 > i {i = $3;v = $0} END{print i,v}'
 
 cat ~/emp.data | awk 'NF >= 1 {print $0}'
 
 cat ~/emp.data | awk 'length() > 17 {print $0}'
 
 cat ~/emp.data | awk '{print NF,$0}'
 
 cat ~/emp.data | awk '{print $2,$1}'
 
 cat ~/emp.data | awk '{print $2,$1,$3}'
 
 cat ~/emp.data | awk '{print NR,$2,$3}'
 
 cat ~/emp.data | awk '{print $1,$3}'
 
 cat ~/emp.data | awk '{print $2 + $3}'
 
 cat ~/emp.data | awk 'BEGIN{i = 0} { i += $2 + $3} END{print i}'
