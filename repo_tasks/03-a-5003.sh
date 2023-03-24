#!/bin/bash


cut -d ':' -f5 /etc/passwd | cut -d ',' -f1 | cut -d ' ' -f2 | egrep  '^.{,8}$'
