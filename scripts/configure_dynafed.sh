#!/bin/bash
if [ $# -lt 6 ]
  then
    echo "You must provide: <IAM hostname> <CLIENT id> <CLIENT secret> <CLIENT passphrase> <DYNAFED username> <DYNAFED password>. Exit."
    exit 1
fi
sed -i 's/\(ENV IAM_HOSTNAME=\)\(.*\)/\1'"$1"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(export IAM_HOSTNAME=\)\(.*\)/\1'"$1"'/g' ../dynafed/assets/request_token.sh
sed -i 's/\(\/DC=org\/DC=terena\/DC=tcs\/C=IT\/L=Frascati\/O=Istituto Nazionale di Fisica Nucleare\/CN=\)\(.*\)/\1'"$1"'/g' \
       ../dynafed/assets/vomsdir/indigo-dc/indigo-dc.lsc
sed -i 's/\(ENV CLIENT_ID=\)\(.*\)/\1'"$2"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(export SUBJECT_ID=\)\(.*\)/\1'"$2"'/g' ../dynafed/assets/request_token.sh
sed -i 's/\(ENV CLIENT_SECRET=\)\(.*\)/\1'"$3"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(export SUBJECT_SECRET=\)\(.*\)/\1'"$3"'/g' ../dynafed/assets/request_token.sh
sed -i 's/\(ENV CLIENT_PASSPHRASE=\)\(.*\)/\1'"$4"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(export USERNAME=\)\(.*\)/\1'"$5"'/g' ../dynafed/assets/request_token.sh
sed -i 's/\(export PASSWORD=\)\(.*\)/\1'"$6"'/g' ../dynafed/assets/request_token.sh
