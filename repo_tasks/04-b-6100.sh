#!/bin/bash

ps -eo user,cmd | tr -s ' ' | cut -d' ' -f1,2 | grep 'vim' | sort | uniq -c | awk '$1 >= 2 {print $2}'
