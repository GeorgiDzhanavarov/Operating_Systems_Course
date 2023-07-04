#!/bin/bash

if [[ $# -ne 1 ]]; then
        echo "Expecting 1 aargument"
        exit 1
fi

if [[ ! -f  $1 ]] then
        echo "Expecting file"
        exit 2
fi

top_visited_saits=$(cut -d ' ' -f2 $1 | sort| uniq -c | sort -nr | head -3| awk '{print $2}')

sait_data=$(mktemp)

for sait in $top_visited_saits; do
        grep "\<$sait\>" $1 > $sait_data
        cat "$sait_data"| awk -v sait=$sait '
        BEGIN { http_count=0; non_http_count=0}
        {
                if ($8 == "HTTP/2.0") {http_count+=1}
                else {non_http_count+=1}
        }END { print $8,sait,"HTTP/2.0:",http_count,"non-HTTP/2.0:",non_http_count }
        '
        cat $sait_data| awk ' $9 > 302 {print $1}' | sort | uniq -c | sort -nr | head -5
done
