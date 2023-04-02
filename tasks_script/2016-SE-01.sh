#!/bin/bash

if [ ${#} -ne 1 ]
then
        echo "Nqma film"
        exit 2
fi


if [[ ! -d ${1} ]]
then
  echo "Nqma takuv film"
  exit 1
fi


find ${1} -L -type l
