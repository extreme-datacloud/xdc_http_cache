#!/bin/bash
if [ -f /home/storm/scripts/xauth_list.log ]; then
    while read line
    do 
      xauth add $(echo "$line" | cut -d "'" -f 2)
    done < /home/storm/scripts/xauth_list.log
fi
