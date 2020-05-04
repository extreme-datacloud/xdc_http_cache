#!/bin/bash
if ! pgrep -x "oidc-agent" > /dev/null; then
  eval `oidc-agent`
fi

./oidc_expect.sh
