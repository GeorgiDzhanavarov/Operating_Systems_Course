#!/bin/bash


 cat /etc/passwd | egrep --color '^(.*:){4}[^\s]* [^,]{,8},'
