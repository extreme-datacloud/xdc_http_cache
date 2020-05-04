#!/bin/bash

if ! pgrep -x "oidc-agent" > /dev/null; then
  eval `oidc-agent`
fi

export CLIENT=indigo-test

./oidc_expect.sh

export SUBJECT_TOKEN=$(oidc-token $CLIENT)

davix-put -P grid /home/storm/test_file_3.txt https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt -H "Authorization: Bearer ${SUBJECT_TOKEN}"

davix-ls -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt -H "Authorization: Bearer ${SUBJECT_TOKEN}"

davix-get -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt -H "Authorization: Bearer ${SUBJECT_TOKEN}"

davix-rm -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt -H "Authorization: Bearer ${SUBJECT_TOKEN}"
