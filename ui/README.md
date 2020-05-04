place certs in usercert folder

if run locally  add ui to iam network

docker network connect <iam container network> <ui container>

eval `oidc-agent`

oidc-gen -w device

then overwrite the local conf if any, choose the provide and when the code is provided open a browser an authorize the client.


Add already registered client

oidc-add <client>

ask for password


Request token
export CLIENT=test-local
export SUBJECT_TOKEN=$(oidc-token $CLIENT)

Get token expiration
oidc-token  $CLIENT -e


Get a file from storm webdav
curl -v -s --capath /digicert \
     -L https://<hostname>:<port>/myfed/indigo-dc/test_file_1.txt \
     -o /tmp/test_file_1.txt \
     -H "Authorization: Bearer ${SUBJECT_TOKEN}"

Using davix
proxy
davix-put -P grid <file>  https://storm.example:11443/indigo-dc/test_file_2.txt

token
davix-put -H "Authorization: Bearer ${SUBJECT_TOKEN}" /home/storm/test_file_3.txt  https://storm.example:11443/indigo-dc/test_file_3.txt
davix-get  -H "Authorization: Bearer ${SUBJECT_TOKEN}"   https://storm.example:11443/indigo-dc/test_file_3.txt
davix-rm  -H "Authorization: Bearer ${SUBJECT_TOKEN}"   https://storm.example:11443/indigo-dc/test_file_3.txt
davix-ls  -H "Authorization: Bearer ${SUBJECT_TOKEN}"   https://storm.example:11443/indigo-dc/
