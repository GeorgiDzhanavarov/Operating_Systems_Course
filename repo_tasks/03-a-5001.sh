#!/bin/bash

cut -d ':' -f 7 /etc/passwd | grep -v '/bin/bash' | wc -l 
