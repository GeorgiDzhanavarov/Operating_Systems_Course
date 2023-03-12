#!/bin/bash

mkdir ~/myetc
find /etc -type f -perm -ugo=r -exec cp {} ~/myetc \;
