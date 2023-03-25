#!/bin/bash


grep  '/home/SI' ~/mypass | cut -d':' -f1 | sort > ~/si.txt
