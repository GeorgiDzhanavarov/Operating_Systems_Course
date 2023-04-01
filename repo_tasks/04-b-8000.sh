#!/bin/bash

 ps -eo pid=,comm=,tty= | tr -s ' ' | awk '$3 == "?"{print $2}' | ps -eo pid=,comm=,tty= | tr -s ' ' | awk '$NF == "?"{print $(NF-1)}' | sort | uniq
