#!/bin/bash

if ! pgrep -x "oidc-agent" > /dev/null; then
  eval `oidc-agent`
fi

export CLIENT=indigo-test

./oidc_expect.sh

export SUBJECT_TOKEN=$(oidc-token $CLIENT)

curl -v -s --capath /digicert \
     -L https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_1.txt \
     -o /tmp/test_file_1.txt \
     -H "Authorization: Bearer ${SUBJECT_TOKEN}"
