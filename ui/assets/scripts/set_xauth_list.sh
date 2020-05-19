#!/bin/bash
if [ -f /home/storm/scripts/xauth_list.log ]; then
    printf '%s\n' "$(cat /home/storm/scripts/xauth_list.log | grep ${HOSTNAME})" \
           > /home/storm/scripts/xauth_list_grep.log
    while read line
    do
      xauth add $(echo "$line" | cut -d "'" -f 2)
    done < /home/storm/scripts/xauth_list_grep.log
fi
