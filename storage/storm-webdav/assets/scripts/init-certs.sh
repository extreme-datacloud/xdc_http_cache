#!/bin/bash
set -ex

CERT_DIR=${CERT_DIR:-/certs/digicert}

#sudo cp ${CERT_DIR}/* /etc/grid-security/storm-webdav/
sudo cp ${CERT_DIR}/ds-507.cr.cnaf.infn.it.pem /etc/grid-security/storm-webdav/hostcert.pem
sudo cp ${CERT_DIR}/ds-507.cr.cnaf.infn.it.key /etc/grid-security/storm-webdav/hostkey.pem
sudo chown -R storm:storm /etc/grid-security/storm-webdav
