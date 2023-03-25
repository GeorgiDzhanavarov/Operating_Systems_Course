#!/bin/bash

find /usr/include -type f -name *.[ch] | wc -l


find /usr/include -type f -name *.[ch] -exec wc -l {} \; | awk 'Begin {i = 0} {i += $1} END {print i}'
