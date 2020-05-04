#!/bin/bash
ID=`/usr/bin/docker ps | grep http_storage_demo_ui | awk '{print $1}'`
NETWORKID=`/usr/bin/docker network ls | grep storm-webdav_default | awk '{print $1}'`
/usr/bin/docker network connect $NETWORKID $ID
