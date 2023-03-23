#!/bin/bash


find /bin -type f -exec file {} \; | grep 'shell script' | wc -l 
