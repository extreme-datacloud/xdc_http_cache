#!/bin/bash
ID=`/usr/bin/docker ps | grep http_storage_demo_ui | awk '{print $1}'`
/usr/bin/docker exec -it $ID /bin/bash
