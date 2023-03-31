#!/bin/bash

ps -eo user,size | grep 'root' | awk -F' ' 'BEGIN{i=0}{i+=$NF} END{print i}'
