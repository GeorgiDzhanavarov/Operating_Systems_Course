#!/bin/bash

egrep -o -i '[a-z]*' /etc/services | sort | uniq -c | sort -t ' ' -k 1 -n -r  | head -n 10
