#!/bin/bash

if [[ -z ${SUBJECT_TOKEN} ]]; then
  echo "Please set the SUBJECT_TOKEN so that it points to an IAM access token."
  exit 1
fi

userinfo=$(curl -s -L -H "Authorization: Bearer ${SUBJECT_TOKEN}" ${IAM_USERINFO_ENDPOINT:-https:///userinfo})

if [[ $? != 0 ]]; then
  echo "Error!"
  echo $userinfo
  exit 1
fi

export SUBJECT_HASH=$(echo $userinfo | jq '.sub')
