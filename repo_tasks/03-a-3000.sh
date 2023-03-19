#!/bin/bash

df -P > ~/result.txt

tail -n +2 result.txt | sort -n -k 2 
