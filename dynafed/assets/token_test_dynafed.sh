#!/bin/bash

export IAM_TOKEN_ENDPOINT=https://iam.local.io/token
export SUBJECT_ID=686393af-a00a-492d-9d7c-23583741d531
export SUBJECT_SECRET=AOoxzJI6J9MuI_XByST2VmRVz6VWhHjK20Du_TcYTwDprWi9MWJBjsU52c9ildw-ueFfxmVN9NSQVg0C91JMq0w
export USERNAME=dynafed.local
export PASSWORD=iam_test_dynafed

curl -s --capath /etc/grid-security/certificates \
  --cert /digicert/cloud-vm159_cloud_cnaf_infn_it.crt \
  --key /digicert/cloud-vm159_cloud_cnaf_infn_it.key \
  -u $SUBJECT_ID:$SUBJECT_SECRET \
  -d username=$USERNAME \
  -d password=$PASSWORD \
  -d grant_type=password \
  -d scope="openid profile" \
  $IAM_TOKEN_ENDPOINT | tee /tmp/response | jq

export SUBJECT_TOKEN=$(cat /tmp/response | jq -r .access_token)

curl -v -s --capath /etc/grid-security/certificates \
     --cert /digicert/cloud-vm159_cloud_cnaf_infn_it.crt \
     --key /digicert/cloud-vm159_cloud_cnaf_infn_it.key \
     -L https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_1.txt \
     -H "Authorization: Bearer ${SUBJECT_TOKEN}" \
     -o /tmp/test_file_1.txt
