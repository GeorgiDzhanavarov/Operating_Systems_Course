#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "Expecting 2 arguments"
        exit 1
fi


if [[ ! -d $1 ]]; then
        echo "Expecting directory"
        exit 2
fi

if [[ ! -d $2 ]]; then
        echo "Expecting directory"
    exit 2
fi

pkg=$2
repo=$1

temp_repo=$(mktemp)
tar -cvJf $temp_repo $pkg/tree

pkg_version="$(basename $pkg)-$(cat $pkg/version)"
sum=$(sha256sum $temp_repo | cut -d ' ' -f1 )

mv -f "$temp_repo" "$repo/packages/$sum.tar.xz"

temp_db=$(mktemp)
cat $repo/db | awk -v v=$pkg_version -v sum=$sum '$1 != v {print v, sum}' > $temp_db

sort -v $temp_db >> cat $repo/db

rm $temp_db $temp_repo
