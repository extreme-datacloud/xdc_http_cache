#!/bin/bash
if [ "$HOSTNAME" = "$1" ]; then
    newIP=131.154.97.142
    if [ `cat /etc/hosts | grep $1 | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b'` ]; then
        oldIP=$(cat /etc/hosts | grep $1 | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
        sudo cp /etc/hosts /hosts.new
        sudo chown storm:storm /hosts.new
        sed -i "s/$oldIP/$newIP/g" /hosts.new
        yes | sudo cp /hosts.new /etc/hosts
        sudo rm -f /hosts.new
    else
        sudo cp /etc/hosts /hosts.new
        sudo chown storm:storm /hosts.new
        printf '%s\n' "${newIP} $1" >> /hosts.new
        yes | sudo cp /hosts.new /etc/hosts
        sudo rm -f /hosts.new
    fi
fi
