#!/bin/bash

comm -2 -3 <(ps -eo user= | sort) <(who | cut -d' ' -f1 | sort) | uniq
