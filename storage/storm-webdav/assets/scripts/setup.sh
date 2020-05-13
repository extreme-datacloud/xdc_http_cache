#!/bin/bash
set -ex

/scripts/init-certs.sh
/scripts/init-sa-config.sh
/scripts/init-storage.sh

# Setup VOMSDIR
sudo mkdir -p /etc/grid-security/vomsdir
sudo cp -r /vomsdir/* /etc/grid-security/vomsdir

# Setup CA CERTS
sudo cp /digicert/FullchainHost.pem /etc/grid-security/certificates/
sudo cp /digicert/Fullchain.pem /etc/grid-security/certificates/
