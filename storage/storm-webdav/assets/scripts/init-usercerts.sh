#!/bin/bash
set -ex

USER_CERTS_DIR=${USER_CERTS_DIR:-/usercerts}
sudo mkdir -p /tmp/usercerts
sudo cp ${USER_CERTS_DIR}/* /tmp/usercerts
sudo chown -R storm:storm /tmp/usercerts
sudo chmod 600 /tmp/usercerts/*
