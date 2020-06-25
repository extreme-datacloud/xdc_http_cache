#!/bin/bash
if ! [[ `rpm -qa | grep xdg-utils || which xdg-open` ]]; then
    sudo yum install -y xmlto
    cd /home/storm/
    wget https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz
    tar xzvf xdg-utils-1.1.2.tar.gz
    cd xdg-utils-1.1.2
    ./configure --prefix="/usr/local"
    sudo make
    sudo make install
    cd ..
    sudo rm -rf xdg-utils-1.1.2*
else
    currentver="$(xdg-open --version | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')"
    requiredver="1.1.2"
    if ! [[ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]]; then
        sudo yum install -y xmlto
        cd /home/storm/
        wget https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz
        tar xzvf xdg-utils-1.1.2.tar.gz
        cd xdg-utils-1.1.2
        ./configure --prefix="/usr/local"
        sudo make
        sudo make install
        cd ..
	sudo rm -rf xdg-utils-1.1.2*
    fi
fi

