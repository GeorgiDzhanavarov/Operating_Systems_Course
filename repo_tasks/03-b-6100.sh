#!/bin/bash

head -n 46 /etc/passwd | tail +28 | cut -d':' -f3 | sed -E 's/(.)/\1 /g' | awk -F' ' '{print $NF}'
