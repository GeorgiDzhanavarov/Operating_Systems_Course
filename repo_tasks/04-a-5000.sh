#!/bin/bash


ps -eo cmd,start --sort=start | head -n 10 | cut -d' ' -f1
