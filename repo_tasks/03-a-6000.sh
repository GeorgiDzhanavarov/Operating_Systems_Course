#!/bin/bash

 cat ~/emp.data | awk 'BEGIN {i = 0} {i += 1} END {print(i)}'
 