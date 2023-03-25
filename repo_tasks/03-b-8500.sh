#!/bin/bash

cat /etc/group | cut -d':' -f 1 | awk -v i=$(groups) '{if ($0 == i) {print "Hello, " $0" - I am here!"} else
{print "Hello, "$0}}'
