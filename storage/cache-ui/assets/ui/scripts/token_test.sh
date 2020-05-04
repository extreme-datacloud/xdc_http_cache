#!/bin/bash

export IAM_TOKEN_ENDPOINT=https://iam.local.io/token
export SUBJECT_ID=686393af-a00a-492d-9d7c-23583741d531
export SUBJECT_SECRET=AOoxzJI6J9MuI_XByST2VmRVz6VWhHjK20Du_TcYTwDprWi9MWJBjsU52c9ildw-ueFfxmVN9NSQVg0C91JMq0w
export USERNAME=ffornari
export PASSWORD=iam_test_ff_90

curl -s --capath /trust-anchors \
  --cert /home/storm/.globus/usercert.pem \
  --key /home/storm/.globus/rsakey.pem \
  -u $SUBJECT_ID:$SUBJECT_SECRET \
  -d username=$USERNAME \
  -d password=$PASSWORD \
  -d grant_type=password \
  -d scope="openid profile" \
  $IAM_TOKEN_ENDPOINT | tee /tmp/response | jq

export SUBJECT_TOKEN=$(cat /tmp/response | jq -r .access_token)

curl -s -v --capath /digicert \
     --cert /home/storm/.globus/usercert.pem \
     --key /home/storm/.globus/rsakey.pem \
     -L https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_1.txt \
     -o /tmp/test_file_1.txt \
     -H "Authorization: Bearer ${SUBJECT_TOKEN}"
