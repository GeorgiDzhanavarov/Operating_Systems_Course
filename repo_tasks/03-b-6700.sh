#!/bin/bash


find /tmp -type f -readable -exec ls -l {} \; | awk '{print $1,$NF}' | awk -F'/' '{print $1,$NF}'
