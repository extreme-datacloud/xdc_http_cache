#!/bin/bash
set -ex

/scripts/init-certs.sh
/scripts/init-sa-config.sh
/scripts/init-storage.sh

# Setup VOMSDIR
sudo mkdir -p /etc/grid-security/vomsdir
sudo cp -r /vomsdir/* /etc/grid-security/vomsdir
