#!/bin/bash
sed -i 's/\(ENV UID=\)\(.*\)/\1'"$(id -u)"'/g' assets/docker/Dockerfile
iam_ip_addr=$(host `hostname` | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
sed -i 's/\(newIP=\)\(.*\)/\1'"$iam_ip_addr"'/g' assets/scripts/replace_iam_ip.sh
xauth list > assets/scripts/xauth_list.log
docker-compose build
docker run \
   -it \
   --net host \
   -v /tmp/.X11-unix:/tmp/.X11-unix \
   -v $PWD/../../xdc_http_cache:/xdc_http_cache \
   -e DISPLAY=$DISPLAY \
   configure_services

rm -f core.*
