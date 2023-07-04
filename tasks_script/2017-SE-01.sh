#!/bin/bash


if [[ $# -lt 1 ]]; then
        echo "Not enough arguments"
        exit 1
fi

if [[ ! -d ${1} ]]; then
        echo "first argument is expected to be dir"
        exit 2
fi

case ${#} in
        1)
                find -L ${1} -type l
                ;;
        2)
                find ${1} -type f -printf "%p %n\n"| awk -v num=${2} '$2 >= num {print $1}'
                ;;
        *)
                echo "I don't expect to receive more than 2 args"
                exit 3
                ;;
esac
