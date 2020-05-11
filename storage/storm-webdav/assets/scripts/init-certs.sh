#!/bin/bash
set -ex

CERT_DIR=${CERT_DIR:-/certs}

sudo cp ${CERT_DIR}/hostcert.pem /etc/grid-security/storm-webdav/hostcert.pem
sudo cp ${CERT_DIR}/hostkey.pem /etc/grid-security/storm-webdav/hostkey.pem
sudo chown -R storm:storm /etc/grid-security/storm-webdav
