#!/bin/bash

cat ~/emp.data | awk -F' ' '{s= "";for (i = NF;i>0;i--) s = s FS $i; print s}'
