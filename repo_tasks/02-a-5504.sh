#!/bin/bash

find /tmp -type f  -group students -perm -g=w -o -perm -o=w
