#!/bin/bash

head -n 12 /etc/passwd
head -c 26 /etc/passwd
head -n -4 /etc/passwd
tail -n 17 /etc/passwd
head -n 149 /etc/passwd | tail -n 1 
head -n 13 /etc/passwd | tail -n 1 | tail -c 4 
