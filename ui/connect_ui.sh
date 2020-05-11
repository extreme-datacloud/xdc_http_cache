#!/bin/bash
docker run \
   -it \
   --net host \
   -v /tmp/.X11-unix:/tmp/.X11-unix \
   -v $PWD/assets/oidc-agent:/home/storm/.oidc-agent:rw \
   -e DISPLAY=$DISPLAY \
   http_storage_demo_ui  

