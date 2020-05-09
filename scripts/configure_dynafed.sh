#!/bin/bash
if [ $# -lt 1 ]
  then
    echo "You must provide: <IAM hostname>. Exit."
    exit 1
fi

sed -i 's/\(ENV IAM_HOSTNAME=\)\(.*\)/\1'"$1"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(\/DC=org\/DC=terena\/DC=tcs\/C=IT\/L=Frascati\/O=Istituto Nazionale di Fisica Nucleare\/CN=\)\(.*\)/\1'"$1"'/g' \
       ../dynafed/assets/vomsdir/indigo-dc/indigo-dc.lsc

if ! [[ `rpm -qa | grep firefox` ]]; then
    sudo yum install -y mesa-libGL
    sudo yum install -y dbus-x11    
    sudo yum install -y firefox
fi
if ! [[ `rpm -qa | grep bind-utils` ]]; then
    sudo yum install -y bind-utils
fi
if ! [[ `rpm -qa | grep jq` ]]; then
    sudo yum install -y jq
fi
if ! [[ `rpm -qa | grep expect` ]]; then
    sudo yum install -y expect
fi
if ! [[ `rpm -qa | grep xdg-utils` ]]; then
    sudo yum install -y xdg-utils
fi
if ! [[ `rpm -qa | grep oidc-agent` ]]; then
    sudo yum install -y http://repo.indigo-datacloud.eu/repository/deep-hdc/production/1/centos7/x86_64/third-party/oidc-agent-3.1.1-1.x86_64.rpm
fi
if ! [[ `ls /etc/grid-security/certificates` ]]; then
    sudo cp ../ui/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
    sudo yum install -y ca-policy-egi-core fetch-crl sharutils
fi
if ! [[ `ls /etc/grid-security/certificates/FullchainHost.pem` ]]; then
    sudo cp ../ui/assets/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
fi
if ! [[ `ls /etc/pki/ca-trust/source/anchors/FullchainHost.pem` ]]; then
    sudo cp ../ui/assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
fi
sudo update-ca-trust
echo "Please, register an IAM account for Dynafed. Opening Firefox..."
firefox https://$1/
echo "Now, register a token exchange client for Dynafed. Starting oidc-agent..."
echo "(Notice: You must enter IAM's endpoint URL, i.e. https://"$1"/, as Issuer when prompted)"
source ../dynafed/assets/register_client.sh
printf 'Finally, enter encryption Password for the last time: '
read -rs client_passphrase
client_name=$(ls -l ~/.oidc-agent/ | grep -v issuer.config | awk '{if(NR>1)print $9}')
client_id=$(oidc-gen --pw-cmd="echo "$client_passphrase --print "$client_name" | jq '.client_id')
client_secret=$(oidc-gen --pw-cmd="echo "$client_passphrase --print "$client_name" | jq '.client_secret')
oidc-agent --kill 2>&1 > /dev/null
cp ~/.oidc-agent/* ../dynafed/assets/oidc-agent/
rm -rf ~/.oidc-agent/*

sed -i 's/\(ENV CLIENT_ID=\)\(.*\)/\1'"$client_id"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(ENV CLIENT_SECRET=\)\(.*\)/\1'"$client_secret"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(ENV CLIENT_PASSPHRASE=\)\(.*\)/\1'"$client_passphrase"'/g' ../dynafed/assets/Dockerfile
sed -i 's/\(export CLIENT=\)\(.*\)/\1'"$client_name"'/g' ../dynafed/assets/oidc_get_token.sh
sed -i 's/\(set CLIENT {\)\(.*\)/\1'"$client_name}"'/g' ../dynafed/assets/oidc_expect.sh
sed -i 's/\(set PASSWORD {\)\(.*\)/\1'"$client_passphrase}"'/g' ../dynafed/assets/oidc_expect.sh

printf '\nHow many endpoints is Dynafed going to federate? '
read -r num_endpoints
re='^[0-9]+$'
while ! [[ $num_endpoints =~ $re ]] ; do
   printf '\nerror: Not a number\n' >&2
   printf '\nHow many endpoints is Dynafed going to federate? '
   read -r num_endpoints
done

declare -a endpoint_urls

for i in $(seq 1 $num_endpoints)
do
    printf '\nEnter endpoint'"'"'s URL n. '"$i"': '
    read -r url
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    while ! [[ $url =~ $regex ]]
    do
      	printf '\nURL not valid'
        printf '\nEnter endpoint'"'"'s URL n. '"$i"': '
        read -r url
    done
    endpoint_urls+=("$url")
done

cp /dev/null ../dynafed/assets/endpoints.conf

length=`expr "${#endpoint_urls[@]}" - 1`

for i in $(seq 0 "$length")
do
  endpoint_index=`expr "$i" + 1`
  printf 'glb.locplugin[]: /usr/local/lib64/ugr/libugrlocplugin_dav.so LOCAL-WEBDAV-%s 5 %s
locplugin.LOCAL-WEBDAV-%s.custom_header[]: Authorization: Bearer
locplugin.LOCAL-WEBDAV-%s.metalink_support: true
locplugin.LOCAL-WEBDAV-%s.listable: true
locplugin.LOCAL-WEBDAV-%s.writable: true
locplugin.LOCAL-WEBDAV-%s.readable: true
locplugin.LOCAL-WEBDAV-%s.xlatepfx: /indigo-dc/ /\n\n' \
"$endpoint_index" \
""${endpoint_urls["$i"]}"" \
"$endpoint_index" \
"$endpoint_index" \
"$endpoint_index" \
"$endpoint_index" \
"$endpoint_index" \
"$endpoint_index" >> ../dynafed/assets/endpoints.conf
done

iam_ip_addr=$(host $1 | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
sed -i 's/\(newIP=\)\(.*\)/\1'"$iam_ip_addr"'/g' ../dynafed/assets/replace_iam_ip.sh

printf '\nConfiguration completed!\n'
