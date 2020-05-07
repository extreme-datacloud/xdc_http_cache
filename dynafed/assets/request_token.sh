#!/bin/bash
export IAM_HOSTNAME=
export IAM_TOKEN_ENDPOINT=https://$IAM_HOSTNAME/token
export SUBJECT_ID=
export SUBJECT_SECRET=
export USERNAME=
export PASSWORD=

curl -s --capath /etc/grid-security/certificates \
  --cert /digicert/hostcert.pem \
  --key /digicert/hostkey.pem \
  -u $SUBJECT_ID:$SUBJECT_SECRET \
  -d username=$USERNAME \
  -d password=$PASSWORD \
  -d grant_type=password \
  -d scope="openid profile" \
  $IAM_TOKEN_ENDPOINT | tee /tmp/response | jq

cp /etc/ugr/conf.d/endpoints.conf /endpoints.new
sed -i 's/\(Authorization\: Bearer \)\(.*\)/\1'"$(cat /tmp/response | jq -r .access_token)"'/g' /endpoints.new
yes | cp -f /endpoints.new /etc/ugr/conf.d/endpoints.conf
rm -f /endpoints.new
