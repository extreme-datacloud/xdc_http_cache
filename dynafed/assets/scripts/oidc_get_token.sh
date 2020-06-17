#!/bin/bash

source /etc/profile.d/oidc-agent.sh

export CLIENT=

export SUBJECT_TOKEN=$(oidc-token $CLIENT)

cp /etc/ugr/conf.d/endpoints.conf /endpoints.new
sed -i 's/\(Authorization\: Bearer\)\(.*\)/\1'" $(echo $SUBJECT_TOKEN)"'/g' /endpoints.new
yes | cp -f /endpoints.new /etc/ugr/conf.d/endpoints.conf
rm -f /endpoints.new
