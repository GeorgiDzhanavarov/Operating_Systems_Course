#!/bin/bash


ls ~/songs | egrep -o '\(.*\)' | tr -d '(' | tr -d ')' | sort -n -t',' -k2
