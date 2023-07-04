#!/bin/bash


if [[ ${#} -ne 3 ]]; then
        echo "3 arguments are expected"
        exit 1
fi

if ! [[ -f ${1} ]]; then
        echo "first arguments should be file"
        exit 2
fi

if [[ -z ${2} || -z ${3} ]]; then
        echo "the string should be longer than zero"
        exit 3
fi

str1=""
str2=""
while read line; do

        if [[ ${line} =~ ^${2}= ]]; then
                str1=$(echo "${line}"| cut -d'=' -f2- )
        fi

    if [[ ${line} =~ ^${3}= ]]; then
        str2=$(echo "${line}"| cut -d'=' -f2-)
    fi

        updated_line=$(comm -13 <(echo "${str1}"| tr ' ' '\n' | sort ) <(echo "${str2}"| tr ' ' '\n' | sort) | tr '\n' ' ')

done< <(cat ${1})
sed -i -e "s/^${3}=${str2}/${3}=${updated_line}/" ${1} # it shouldbe in double quotes
