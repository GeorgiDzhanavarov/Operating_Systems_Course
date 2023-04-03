#!/bin/bash



if [[ $(whoami) !=  root ]];
then
  echo "not root"
  exit 1
fi

cat /etc/passwd | while read line; do
user = $(echo $line | cut -d':' -f1)
home = $(echo $line | cut -d':' -f6)


if [[ -d $home ]]; then
  echo "$user has no homedir set"
  continue
fi

dirperm = $(ls -ld $home | awk '{print $1}')

if [[ $(echo $dirperm | cut -c 3)) != "w" ]]; then
  echo "$user cannot write in $home"
fi
done
