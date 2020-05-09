#!/bin/bash
if [ "$HOSTNAME" = "$1" ]; then
    oldIP=$(cat /etc/hosts | grep $1 | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
    newIP=
    cp /etc/hosts /hosts.new
    sed -i "s/$oldIP/$newIP/g" /hosts.new
    yes | cp /hosts.new /etc/hosts
    rm -f /hosts.new
fi
