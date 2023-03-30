#!/bin/bash

ps -eo cmd,start --sort=start | head -n 1 | cut -d' ' -f1
