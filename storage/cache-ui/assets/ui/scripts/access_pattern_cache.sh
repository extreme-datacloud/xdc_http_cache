#!/bin/bash

RENEW=60
CACHE=$1'.cr.cnaf.infn.it:13443'
TEMP='/tmp/filelist'

function get_token(){
  killall oidc-agent
  eval `oidc-agent`
  export CLIENT=test-local
  ./oidc_expect.sh
  export SUBJECT_TOKEN=$(oidc-token $CLIENT)
  export TOKEN_AT=$(oidc-token  $CLIENT -e)
}

function build_file_list(){
  ENDPOINT=https://$CACHE/indigo-dc
  echo '/usr/bin/davix-ls -H "Authorization: Bearer ${SUBJECT_TOKEN}" https://$CACHE/indigo-dc > ' $TEMP
  /usr/bin/davix-ls -H "Authorization: Bearer ${SUBJECT_TOKEN}" https://$CACHE/indigo-dc > $TEMP
  STATUS=$?
  echo 'STATUS ' $STATUS
  if [ $STATUS -eq 0 ] 
  then
    echo "SUCCESS: Filelist to filelist" 
    cat $TEMP
  else 
    echo "ERROR: Failed to get filelists" 
    exit 1
  fi 
}

function data_access(){
  echo 'Data access'
  ENDPOINT=https://$CACHE/indigo-dc
  for f in `cat $TEMP`;do
    START=`date +"%s"`   
    /usr/bin/davix-get -H "Authorization: Bearer ${SUBJECT_TOKEN}" $ENDPOINT/$f >> /dev/null
    END=`date +"%s"`
    echo "Down loaded FILE in " $(($END - $START)) "s"
  done
}

get_token

build_file_list

while (true) 
do
  NOW=`date +"%s"`
  sleep 1
  echo $TOKEN_AT
  echo $NOW
  if ((TOKEN_AT - NOW > RENEW))
  then 
    DSSTART=`date +"%s"`    
    data_access
    DSEND=`date +"%s"`
    echo "Downloaded FILESET in " $(($DSEND - $DSSTART)) "s"
  else
    echo "Renew token"
    get_token
    build_file_list
  fi
done

echo "End loop"
