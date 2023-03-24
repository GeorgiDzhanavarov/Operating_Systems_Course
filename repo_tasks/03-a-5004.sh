#!/bin/bash


cat /etc/passwd | egrep  '^(.*:){4}.* .{,8}'
