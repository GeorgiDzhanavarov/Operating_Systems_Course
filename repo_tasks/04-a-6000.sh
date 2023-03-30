#!/bin/bash

ps  -eo pid,cmd,vsize --sort=vsize | tail -n 1 | tr -s ' ' | cut -d' ' -f1,2
