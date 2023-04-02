#!/bin/bash


function count_children() {
        ps --ppid="${1}" | tail -n +2 | wc -l
}

ps -eo pid=,ppid= | while read PID1 PID2; do
        [ $(count_children "${PID1}") -ge $(count_children "${PID2}") ] && echo "${PID1}"
done 2>/dev/null
