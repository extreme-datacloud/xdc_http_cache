#!/bin/bash

if ! pgrep -x "oidc-agent" > /dev/null; then
  eval `oidc-agent`
fi

export CLIENT=

../ui/assets/scripts/oidc_expect.sh

export SUBJECT_TOKEN=$(oidc-token $CLIENT)
