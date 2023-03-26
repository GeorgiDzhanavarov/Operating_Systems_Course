#!/bin/bash

cat ~/population.csv | sed -E 's/^([^"][^,]*),/"\1",/g' | egrep ',1969,' | sed -E 's/^(".*"),[^,]*,[^,]*,([^,]*)/\1 \2/g' | sort -t'"' -k3 -n -r | sed -n '42p'
