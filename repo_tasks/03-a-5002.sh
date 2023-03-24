#!/bin/bash

cut /etc/passwd -d ':' -f5 | cut -d ',' -f1 | cut -d ' ' -f2 | egrep  '^.{7,}$'
