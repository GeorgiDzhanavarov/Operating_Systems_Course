#!/bin/bash

cat /etc/passwd | grep $(whoami) 

cat /etc/passwd | grep -B 2 $(whoami) 

cat /etc/passwd | grep -B 2 -A 3 $(whoami) 

cat /etc/passwd | grep -B 3 $(whoami) | head -n 1 
