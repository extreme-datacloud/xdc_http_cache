#!/bin/bash

if ! [[ `rpm -qa | grep firefox` ]]; then
    sudo yum install -y mesa-libGL
    sudo yum install -y dbus-x11    
    sudo yum install -y firefox
fi
if ! [[ `rpm -qa | grep bind-utils` ]]; then
    sudo yum install -y bind-utils
fi
if ! [[ `rpm -qa | grep xauth` ]]; then
    sudo yum install -y xauth
fi
if ! [[ `rpm -qa | grep jq` ]]; then
    sudo yum install -y jq
fi
if ! [[ `rpm -qa | grep expect` ]]; then
    sudo yum install -y expect
fi
if ! [[ `rpm -qa | grep xdg-utils || which xdg-open` ]]; then
    sudo yum install -y xmlto
    wget https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz
    tar xzvf xdg-utils-1.1.2.tar.gz
    cd xdg-utils-1.1.2
    ./configure --prefix="/usr/local"
    sudo make
    sudo make install
    cd ..
    sudo rm -rf xdg-utils-1.1.2*
else
    currentver="$(xdg-open --version | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')"
    requiredver="1.1.2"
    if ! [[ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]]; then
        sudo yum install -y xmlto
        wget https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz
        tar xzvf xdg-utils-1.1.2.tar.gz
        cd xdg-utils-1.1.2
        ./configure --prefix="/usr/local"
        sudo make
        sudo make install
        cd ..
	sudo rm -rf xdg-utils-1.1.2*
    fi
fi
if ! [[ `rpm -qa | grep oidc-agent` ]]; then
    sudo yum install -y https://github.com/indigo-dc/oidc-agent/releases/download/v3.1.1/oidc-agent-3.1.1-1.x86_64.rpm
fi
if ! [[ `ls /etc/grid-security/certificates 2>/dev/null` ]]; then
    sudo cp ../ui/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
    sudo yum install -y ca-policy-egi-core fetch-crl sharutils
fi
if ! [[ `ls /etc/grid-security/certificates/FullchainHost.pem 2>/dev/null` ]]; then
    sudo cp ../ui/assets/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
fi
if ! [[ `ls /etc/pki/ca-trust/source/anchors/FullchainHost.pem 2>/dev/null` ]]; then
    sudo cp ../ui/assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
fi
if ! [[ `ls /etc/grid-security/certificates/FullchainHostSectigo.pem 2>/dev/null` ]]; then
    sudo cp ../ui/assets/certs/sectigo/FullchainHostSectigo.pem /etc/grid-security/certificates/
fi
if ! [[ `ls /etc/pki/ca-trust/source/anchors/FullchainHostSectigo.pem 2>/dev/null` ]]; then
    sudo cp ../ui/assets/certs/sectigo/FullchainHostSectigo.pem /etc/pki/ca-trust/source/anchors/
fi
sudo update-ca-trust

printf 'Enter the service to be configured (please, follow the order) [ iam | ui | cache | dynafed | storm-webdav ]: '
read -r service
if [ -n $service ] ; then
    case $service in
      iam)
        sed -i 's/\(  server_name\)\(.*\)/\1'" $HOSTNAME"';/g' ../iam/assets/iam-nginx/iam.conf 
        sed -i 's/\(  server_name\)\(.*\)/\1'" $HOSTNAME"';/g' ../iam/assets/nginx-voms/conf.d/voms-ng.conf
        sed -i 's/\(    host:\)\(.*\)/\1'" $HOSTNAME"'/g' ../iam/assets/etc/vomsng/application.yml 

        lsc_file=$(ls ../iam/assets/vomsdir/indigo-dc)
        lsc_file=${lsc_file%".lsc"}

        if ! [ "$HOSTNAME" = "$lsc_file" ]; then
            mv ../iam/assets/vomsdir/indigo-dc/*.lsc ../iam/assets/vomsdir/indigo-dc/"$HOSTNAME".lsc
        fi

        if [ -f ../certs/hostcert.pem ]; then
            HOST_DN=$(openssl x509 -in ../certs/hostcert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            HOST_ISSUER=$(openssl x509 -in ../certs/hostcert.pem -noout -issuer | awk 'sub("^" $1 FS, _)')
            printf '%s\n%s\n' "$HOST_DN" "$HOST_ISSUER" > ../iam/assets/vomsdir/indigo-dc/"$HOSTNAME".lsc
        else
            printf '\nError: could not find host cert, host DN not added to .lsc file!\n'
            exit 1
        fi

        if [ -f ../ui/assets/usercert/usercert.pem ]; then
            cat ../iam/assets/certs/digicert/DigiCertAssuredIDRootCA.crt ../iam/assets/certs/digicert/TERENAeSciencePersonalCA3.pem ../ui/assets/usercert/usercert.pem > ../iam/assets/certs/digicert/Fullchain.pem
        else
            printf '\nWarning: could not find x509 cert, user VOMS proxy will be rejected by IAM!\n'
        fi

        printf '\niam service successfully configured!\n' 
        ;;

      ui)
        printf '\nEnter IAM hostname: '
        read -r iam_hostname

        lsc_file=$(ls ../ui/assets/vomsdir/indigo-dc)
        lsc_file=${lsc_file%".lsc"}

        if ! [ "$iam_hostname" = "$lsc_file" ]; then
            mv ../ui/assets/vomsdir/indigo-dc/*.lsc ../ui/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        fi

	if [ -f ../certs/hostcert.pem ]; then
            HOST_DN=$(openssl x509 -in ../certs/hostcert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            HOST_ISSUER=$(openssl x509 -in ../certs/hostcert.pem -noout -issuer | awk 'sub("^" $1 FS, _)')
            printf '%s\n%s\n' "$HOST_DN" "$HOST_ISSUER" > ../ui/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        else
            printf '\nError: could not find host cert, host DN not added to .lsc file!\n'
            exit 1
        fi

        sed -i 's/\(ENV UID=\)\(.*\)/\1'"$(id -u)"'/g' ../ui/assets/docker/Dockerfile
        ESCAPED_HOST_DN=$(echo "$HOST_DN" | sed 's/\//\\\//g')
        sed -i 's/\("indigo-dc" "\)\(.*\)/\1'"$iam_hostname"'" "15000" "'"$ESCAPED_HOST_DN"'" "indigo-dc"/g' ../ui/assets/vomses/indigo-dc
        sed -i 's/\(IAM_USERINFO_ENDPOINT:-https:\/\/\)\(.*\)/\1'"$iam_hostname"'\/userinfo})/g' ../ui/assets/scripts/get_userinfo.sh

        printf '\nPlease, register an IAM account for your user. Opening Firefox...\n'
        firefox https://$iam_hostname/
        rm -rf ~/.oidc-agent/*
        rm -rf ~/.config/oidc-agent/*
        printf '\nNow, register a token exchange client for your user. Starting oidc-agent...\n'
        printf '\n(Notice: You must enter IAM'"'"'s endpoint URL, i.e. https://'"$iam_hostname"'/, as Issuer when prompted)\n'
        source ../ui/assets/scripts/register_client.sh
        printf 'Finally, enter encryption Password for the last time: '
        read -rs client_passphrase
        client_name=$((ls -l ~/.oidc-agent/ 2>/dev/null | grep -v issuer.config | awk '{if(NR>1)print $9}') && (ls -l ~/.config/oidc-agent/ 2>/dev/null | grep -v issuer.config | awk '{if(NR>1)print $9}'))
        if [ -d ~/.oidc-agent/ ]; then
            cp -a ~/.oidc-agent/. ../ui/assets/oidc-agent/
        fi
        if [ -d ~/.config/oidc-agent/ ]; then
            cp -a ~/.config/oidc-agent/ ../ui/assets/
        fi

        sed -i 's/\(export CLIENT=\)\(.*\)/\1'"$client_name"'/g' ../ui/assets/scripts/oidc_get_token.sh
        sed -i 's/\(set CLIENT {\)\(.*\)/\1'"$client_name}"'/g' ../ui/assets/scripts/oidc_expect.sh
        sed -i 's/\(set PASSWORD {\)\(.*\)/\1'"$client_passphrase}"'/g' ../ui/assets/scripts/oidc_expect.sh
        printf '\n'
        source ../ui/assets/scripts/oidc_get_token.sh
        source ../ui/assets/scripts/get_userinfo.sh
      
        if [ -f grid-mapfile ]; then
            cp /dev/null grid-mapfile
        else
            touch grid-mapfile
        fi
	if [ -f ../ui/assets/usercert/usercert.pem ]; then
            DN=$(openssl x509 -in ../ui/assets/usercert/usercert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            printf '"%s" .indigo-dc\n' "$DN" >> grid-mapfile
        else
            printf '\nWarning: could not find x509 cert, user DN not added to grid-mapfile!\n'
        fi
	printf '%s .indigo-dc\n' "$SUBJECT_HASH" >> grid-mapfile

        oidc-agent --kill 2>&1 > /dev/null
        rm -rf ~/.oidc-agent/*
        rm -rf ~/.config/oidc-agent/*

        xauth list > ../ui/assets/scripts/xauth_list.log
        
        if [ -f ../ui/assets/usercert/usercert.pem ]; then
            cat ../iam/assets/certs/digicert/DigiCertAssuredIDRootCA.crt ../iam/assets/certs/digicert/TERENAeSciencePersonalCA3.pem ../ui/assets/usercert/usercert.pem > ../ui/assets/certs/digicert/Fullchain.pem
        else
            printf '\nWarning: could not find x509 cert, user VOMS proxy will be rejected!\n'
        fi

        printf '\nui service successfully configured!\n'
        ;;

      cache)
        printf '\nEnter IAM hostname: '
        read -r iam_hostname

        lsc_file=$(ls ../storage/cache/assets/vomsdir/indigo-dc)
        lsc_file=${lsc_file%".lsc"}

        if ! [ "$iam_hostname" = "$lsc_file" ]; then
            mv ../storage/cache/assets/vomsdir/indigo-dc/*.lsc ../storage/cache/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        fi

        if [ -f ../certs/hostcert.pem ]; then
            HOST_DN=$(openssl x509 -in ../certs/hostcert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            HOST_ISSUER=$(openssl x509 -in ../certs/hostcert.pem -noout -issuer | awk 'sub("^" $1 FS, _)')
            printf '%s\n%s\n' "$HOST_DN" "$HOST_ISSUER" > ../storage/cache/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        else
            printf '\nError: could not find host cert, host DN not added to .lsc file!\n'
       	    exit 1
        fi

        sed -i 's/\(        server_name\)\(.*\)/\1'" $HOSTNAME"';/g' ../storage/cache/assets/docker/nginx.conf 
        sed -i 's/\(ENV IAM_HOSTNAME=\)\(.*\)/\1'"$iam_hostname"'/g' ../storage/cache/assets/docker/Dockerfile
        sed -i 's/\(discovery = "https:\/\/\)\(.*\)/\1'"$iam_hostname"'\/.well-known\/openid-configuration",/g' ../storage/cache/assets/docker/nginx.conf

        iam_ip_addr=$(host $iam_hostname | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
        sed -i 's/\(newIP=\)\(.*\)/\1'"$iam_ip_addr"'/g' ../storage/cache/assets/docker/replace_iam_ip.sh

        if [ -f ../ui/assets/usercert/usercert.pem ]; then
            cat ../iam/assets/certs/digicert/DigiCertAssuredIDRootCA.crt ../iam/assets/certs/digicert/TERENAeSciencePersonalCA3.pem ../ui/assets/usercert/usercert.pem > ../storage/cache/assets/certs/digicert/Fullchain.pem
        else
            printf '\nWarning: could not find x509 cert, user VOMS proxy will be rejected by cache!\n'
        fi

        printf '\nHow many cache instances are you going to deploy on this host? '
        read -r num_endpoints
        re='^[0-9]+$'
        while ! [[ $num_endpoints =~ $re ]] ; do
            printf '\nerror: Not a number\n' >&2
            printf '\nHow many cache instances are you going to deploy on this host? '
            read -r num_endpoints
        done

        p_min=1000

        for i in $(seq 1 $num_endpoints)
        do
            cp -a ../storage/cache ../storage/cache_"$i"

            printf '\nEnter cache'"'"'s port for cache n. '"$i"': '
            read -r cache_port
            while ! [[ $cache_port =~ $re && "$cache_port" -gt "$p_min" ]]
            do
                printf '\nport not valid\n'
                printf '\nEnter cache'"'"'s port for cache n. '"$i"': '
                read -r cache_port
            done

            sed -i 's/\(EXPOSE\)\(.*\)/\1'" $cache_port"'/g' ../storage/cache_"$i"/assets/docker/Dockerfile
            sed -i 's/\(        listen\)\(.*\)/\1'" $cache_port"' ssl;/g' ../storage/cache_"$i"/assets/docker/nginx.conf
            sed -i 's/\(      - "\)\(.*\)/\1'"$cache_port"':'"$cache_port"'"/g' ../storage/cache_"$i"/docker-compose.yml

            printf '\nEnter StoRM-WebDAV hostname for cache n. '"$i"': '
            read -r storm_hostname

            printf '\nEnter StoRM-WebDAV'"'"'s HTTPS port for cache n. '"$i"': '
            read -r storm_port
            while ! [[ $storm_port =~ $re && "$storm_port" -gt "$p_min" ]]
            do
              	printf '\nport not valid\n'
                printf '\nEnter StoRM-WebDAV'"'"'s HTTPS port for cache n. '"$i"': '
                read -r storm_port
            done

            sed -i 's/\(ngx.var.proxy = '"'"'\)\(.*\)/\1'"$storm_hostname"':'"$storm_port"''"'"';/g' ../storage/cache_"$i"/assets/docker/nginx.conf
            find ../storage/cache_"$i" -type f -exec sed -i -e 's/cache\//cache_'"$i"'\//g' {} \;
            
        done

        printf '\ncache service successfully configured!\n'
        ;;

      storm-webdav)
        printf '\nEnter IAM hostname: '
        read -r iam_hostname

        lsc_file=$(ls ../storage/storm-webdav/assets/vomsdir/indigo-dc)
        lsc_file=${lsc_file%".lsc"}

        if ! [ "$iam_hostname" = "$lsc_file" ]; then
            mv ../storage/storm-webdav/assets/vomsdir/indigo-dc/*.lsc ../storage/storm-webdav/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        fi        

        if [ -f ../certs/hostcert.pem ]; then
            HOST_DN=$(openssl x509 -in ../certs/hostcert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            HOST_ISSUER=$(openssl x509 -in ../certs/hostcert.pem -noout -issuer | awk 'sub("^" $1 FS, _)')
            printf '%s\n%s\n' "$HOST_DN" "$HOST_ISSUER" > ../storage/storm-webdav/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
            printf '"%s"\n' "$HOST_DN" > ../storage/storm-webdav/assets/etc/storm/webdav/vo-mapfiles.d/indigo-dc.vomap
        else
            printf '\nError: could not find host cert, host DN not added to .lsc file!\n'
            exit 1
       	fi

        sed -i 's/\(ENV IAM_HOSTNAME=\)\(.*\)/\1'"$iam_hostname"'/g' ../storage/storm-webdav/assets/docker/storm/Dockerfile
        sed -i 's/\(orgs=https:\/\/\)\(.*\)/\1'"$iam_hostname"'\//g' ../storage/storm-webdav/assets/etc/storm/webdav/sa.d/indigo-dc.properties
        sed -i 's/\(issuer: https:\/\/\)\(.*\)/\1'"$iam_hostname"'\//g' ../storage/storm-webdav/assets/etc/storm/webdav/config/application.yml
        sed -i 's/\(- name:\)\(.*\)/\1'" $iam_hostname"'/g' ../storage/storm-webdav/assets/etc/storm/webdav/config/application.yml

        iam_ip_addr=$(host $iam_hostname | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
        sed -i 's/\(newIP=\)\(.*\)/\1'"$iam_ip_addr"'/g' ../storage/storm-webdav/assets/scripts/replace_iam_ip.sh

        if [ -f ../ui/assets/usercert/usercert.pem ]; then
            cat ../iam/assets/certs/digicert/DigiCertAssuredIDRootCA.crt ../iam/assets/certs/digicert/TERENAeSciencePersonalCA3.pem ../ui/assets/usercert/usercert.pem > ../storage/storm-webdav/assets/certs/digicert/Fullchain.pem
        else
            printf '\nWarning: could not find x509 cert, user VOMS proxy will be rejected by StoRM-WebDAV!\n'
        fi

        printf '\nHow many StoRM-WebDAV instances are you going to deploy on this host? '
        read -r num_endpoints
        re='^[0-9]+$'
        while ! [[ $num_endpoints =~ $re ]] ; do
            printf '\nerror: Not a number\n' >&2
            printf '\nHow many StoRM-WebDAV instances are you going to deploy on this host? '
            read -r num_endpoints
        done

        p_min=1000

	for i in $(seq 1 $num_endpoints)
        do
            cp -a ../storage/storm-webdav ../storage/storm-webdav_"$i"

            printf '\nEnter StoRM-WebDAV'"'"'s HTTP port for instance n. '"$i"': '
            read -r storm_port
            while ! [[ $storm_port =~ $re && "$storm_port" -gt "$p_min" ]]
            do
              	printf '\nport not valid\n'
                printf '\nEnter StoRM-WebDAV'"'"'s HTTP port for instance n. '"$i"': '
                read -r storm_port
            done

            sed -i 's/\(STORM_WEBDAV_HTTP_PORT=\)\(.*\)/\1'"$storm_port"'/g' ../storage/storm-webdav_"$i"/assets/etc/sysconfig/storm-webdav
            sed -i 's/\(      STORM_WEBDAV_HTTP_PORT:\)\(.*\)/\1'" $storm_port"'/g' ../storage/storm-webdav_"$i"/docker-compose.yml
            sed -i 's/11085/'"$storm_port"'/g' ../storage/storm-webdav_"$i"/docker-compose.yml

            printf '\nEnter StoRM-WebDAV'"'"'s HTTPS port for instance n. '"$i"': '
            read -r storm_port
            while ! [[ $storm_port =~ $re && "$storm_port" -gt "$p_min" ]]
            do
              	printf '\nport not valid\n'
                printf '\nEnter StoRM-WebDAV'"'"'s HTTPS port for instance n. '"$i"': '
                read -r storm_port
            done

            sed -i 's/\(STORM_WEBDAV_HTTPS_PORT=\)\(.*\)/\1'"$storm_port"'/g' ../storage/storm-webdav_"$i"/assets/etc/sysconfig/storm-webdav
            sed -i 's/\(      STORM_WEBDAV_HTTPS_PORT:\)\(.*\)/\1'" $storm_port"'/g' ../storage/storm-webdav_"$i"/docker-compose.yml
            sed -i 's/11443/'"$storm_port"'/g' ../storage/storm-webdav_"$i"/docker-compose.yml
            sed -i 's/1/'"$i"'/g' ../storage/storm-webdav_"$i"/assets/scripts/init-storage.sh

            find ../storage/storm-webdav_"$i" -type f -not -path "*docker/storm*" -not -path "*scripts*" -not -path "*sysconfig*" -exec sed -i -e 's/storm-webdav\//storm-webdav_'"$i"'\//g' {} \;
            sed -i 's/storage\/storm-webdav\//storage\/storm-webdav_'"$i"'\//g' ../storage/storm-webdav_"$i"/assets/docker/storm/Dockerfile

            if [ -f cache_dns.log ]; then
                while IFS= read -r line
                do
                    printf '"%s"\n' "$line" >> ../storage/storm-webdav_"$i"/assets/etc/storm/webdav/vo-mapfiles.d/indigo-dc.vomap
                done < "cache_dns.log"
            else
                printf '\nWarning: dynafed service not yet configured, could not add cache host DNs to vomap files!\n'
            fi
        done

        printf '\nstorm-webdav service successfully configured!\n'
        ;;

      dynafed)
        printf '\nEnter IAM hostname: '
        read -r iam_hostname

        lsc_file=$(ls ../dynafed/assets/vomsdir/indigo-dc)
        lsc_file=${lsc_file%".lsc"}

        if ! [ "$iam_hostname" = "$lsc_file" ]; then
            mv ../dynafed/assets/vomsdir/indigo-dc/*.lsc ../dynafed/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        fi

        if [ -f ../certs/hostcert.pem ]; then
            HOST_DN=$(openssl x509 -in ../certs/hostcert.pem -noout -subject | awk 'sub("^" $1 FS, _)')
            HOST_ISSUER=$(openssl x509 -in ../certs/hostcert.pem -noout -issuer | awk 'sub("^" $1 FS, _)')
            printf '%s\n%s\n' "$HOST_DN" "$HOST_ISSUER" > ../dynafed/assets/vomsdir/indigo-dc/"$iam_hostname".lsc
        else
            printf '\nError: could not find host cert, host DN not added to .lsc file!\n'
            exit 1
        fi

        sed -i 's/\(  ServerName\)\(.*\)/\1'" $HOSTNAME"'/g' ../dynafed/assets/zlcgdm-ugr-dav.conf 
        sed -i 's/\(ENV IAM_HOSTNAME=\)\(.*\)/\1'"$iam_hostname"'/g' ../dynafed/assets/Dockerfile
        
        printf '\nPlease, register an IAM account for Dynafed. Opening Firefox...\n'
        firefox https://$iam_hostname/
        rm -rf ~/.oidc-agent/*
        rm -rf ~/.config/oidc-agent/*
        printf '\nNow, register a token exchange client for Dynafed. Starting oidc-agent...\n'
        printf '\n(Notice: You must enter IAM'"'"'s endpoint URL, i.e. https://'"$iam_hostname"'/, as Issuer when prompted)\n'
        source ../dynafed/assets/register_client.sh
        printf 'Finally, enter encryption Password for the last time: '
        read -rs client_passphrase
        client_name=$((ls -l ~/.oidc-agent/ 2>/dev/null | grep -v issuer.config | awk '{if(NR>1)print $9}') && (ls -l ~/.config/oidc-agent/ 2>/dev/null | grep -v issuer.config | awk '{if(NR>1)print $9}'))
        client_id=$(oidc-gen --pw-cmd="echo "$client_passphrase --print "$client_name" | jq '.client_id')
        client_secret=$(oidc-gen --pw-cmd="echo "$client_passphrase --print "$client_name" | jq '.client_secret')
        oidc-agent --kill 2>&1 > /dev/null

        if [ -d ~/.oidc-agent/ ]; then
            cp -a ~/.oidc-agent/. ../dynafed/assets/oidc-agent/
        fi
	if [ -d ~/.config/oidc-agent/ ]; then
            cp -a ~/.config/oidc-agent/ ../dynafed/assets/
        fi

        rm -rf ~/.oidc-agent/*
        rm -rf ~/.config/oidc-agent/*

        sed -i 's/\(ENV CLIENT_ID=\)\(.*\)/\1'"$client_id"'/g' ../dynafed/assets/Dockerfile
        sed -i 's/\(ENV CLIENT_SECRET=\)\(.*\)/\1'"$client_secret"'/g' ../dynafed/assets/Dockerfile
        sed -i 's/\(ENV CLIENT_PASSPHRASE=\)\(.*\)/\1'"$client_passphrase"'/g' ../dynafed/assets/Dockerfile
        sed -i 's/\(export CLIENT=\)\(.*\)/\1'"$client_name"'/g' ../dynafed/assets/oidc_get_token.sh
        sed -i 's/\(export CLIENT=\)\(.*\)/\1'"$client_name"'/g' ../dynafed/assets/cronjob.sh
        sed -i 's/\(set CLIENT {\)\(.*\)/\1'"$client_name}"'/g' ../dynafed/assets/oidc_expect.sh
        sed -i 's/\(set PASSWORD {\)\(.*\)/\1'"$client_passphrase}"'/g' ../dynafed/assets/oidc_expect.sh

        p_min=1000

        printf '\nEnter Dynafed'"'"'s HTTP port: '
        read -r dynafed_port
        while ! [[ $dynafed_port =~ $re && "$dynafed_port" -gt "$p_min" ]]
        do
            printf '\nport not valid\n'
            printf '\nEnter Dynafed'"'"'s HTTP port: '
            read -r dynafed_port
        done

        sed -i 'H;1h;$!d;x; s/\<EXPOSE\>/\x00/g2' ../dynafed/assets/Dockerfile  
        sed -i 's/\(EXPOSE\)\(.*\)/\1'" $dynafed_port"'/g' ../dynafed/assets/Dockerfile
        sed -i 's/\x00/EXPOSE/g' ../dynafed/assets/Dockerfile
        sed -i 'H;1h;$!d;x; s/      - "/\x00/1' ../dynafed/docker-compose.yml  
        sed -i 's/\(      - "\)\(.*\)/\1'"$dynafed_port"':80"/g' ../dynafed/docker-compose.yml
        sed -i 's/\x00/      - "/g' ../dynafed/docker-compose.yml

        printf '\nEnter Dynafed'"'"'s HTTPS port: '
        read -r dynafed_port
        while ! [[ $dynafed_port =~ $re && "$dynafed_port" -gt "$p_min" ]]
        do
            printf '\nport not valid\n'
            printf '\nEnter Dynafed'"'"'s HTTPS port: '
            read -r dynafed_port
        done

        sed -i 's/\(  && sed -i '"'"'s\/Listen 443 \/Listen\)\(.*\)/\1'" $dynafed_port"'\/g'"'"' \/etc\/httpd\/conf\/httpd.conf \\ /g' ../dynafed/assets/Dockerfile
        sed -i 's/\(  && sed -i '"'"'s\/#OIDCRedirectURI https:\\\/\\\/www.example.com\\\/protected\\\/redirect_uri\/OIDCRedirectURI https:\\\/\\\/iam.local.io:\)\(.*\)/\1'"$dynafed_port"'\\\/myfed\\\/redirect_uri\/g'"'"' \\ /g' ../dynafed/assets/Dockerfile
        sed -i 'H;1h;$!d;x; s/\<EXPOSE\>/\x00/1' ../dynafed/assets/Dockerfile  
        sed -i 's/\(EXPOSE\)\(.*\)/\1'" $dynafed_port"'/g' ../dynafed/assets/Dockerfile
        sed -i 's/\x00/EXPOSE/g' ../dynafed/assets/Dockerfile
        sed -i 's/\(Listen\)\(.*\)/\1'" $dynafed_port"'/g' ../dynafed/assets/zlcgdm-ugr-dav.conf
        sed -i 's/\(\<VirtualHost \*:\)\(.*\)/\1'"$dynafed_port"'\>/g' ../dynafed/assets/zlcgdm-ugr-dav.conf
        sed -i 'H;1h;$!d;x; s/      - "/\x00/g2' ../dynafed/docker-compose.yml  
        sed -i 's/\(      - "\)\(.*\)/\1'"$dynafed_port"':'"$dynafed_port"'"/' ../dynafed/docker-compose.yml
        sed -i 's/\x00/      - "/g' ../dynafed/docker-compose.yml

        printf '\nHow many endpoints is Dynafed going to federate? '
        read -r num_endpoints
        re='^[0-9]+$'
        while ! [[ $num_endpoints =~ $re ]] ; do
            printf '\nerror: Not a number\n' >&2
            printf '\nHow many endpoints is Dynafed going to federate? '
            read -r num_endpoints
        done

        declare -a endpoint_urls
        declare -a endpoint_dns

        DN_FIELDS=$(printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n' "C" "CN" "DC" "L" "O" "OU" "ST")
        echo "$DN_FIELDS" > "dn_fields"

        for i in $(seq 1 $num_endpoints)
        do
            printf '\nEnter endpoint'"'"'s URL n. '"$i"': '
            read -r u
            regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
            while ! [[ $u =~ $regex ]]
            do
      	        printf '\nURL not valid\n'
                printf '\nEnter endpoint'"'"'s URL n. '"$i"': '
                read -r u
            done
            endpoint_urls+=("$u")

            printf '\nEnter endpoint'"'"'s DN n. '"$i"': '
            read -r dn
            DN_CONTENT=$(echo "$dn" | grep -oE '([^\/]|\\.)*' | awk -F' *= *' '{print $1}' | sort -u)
            echo "$DN_CONTENT" > "dn_content"
            while ! [[ `comm -13 <(sort -u dn_fields) <(sort -u dn_content) | wc -l` == "0" ]]
            do
                printf '\nDN not valid\n'
                printf '\nEnter endpoint'"'"'s DN n. '"$i"': '
                read -r dn
                DN_CONTENT=$(echo "$dn" | grep -oE '([^\/]|\\.)*' | awk -F' *= *' '{print $1}' | sort -u)
                echo "$DN_CONTENT" > "dn_content"
            done

            endpoint_dns+=("$dn")    
        done

        rm -f dn_fields
        rm -f dn_content

        dns_unique=()
        while IFS= read -r -d '' x
        do
            dns_unique+=("$x")
        done < <(printf "%s\0" "${endpoint_dns[@]}" | sort -uz)

        if [ -f cache_dns.log ]; then
            cp /dev/null cache_dns.log
        else
            touch cache_dns.log            
        fi
        for i in "${dns_unique[@]}"
        do
            printf '%s\n' "$i" >> cache_dns.log
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

        iam_ip_addr=$(host $iam_hostname | grep -oE '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b')
        sed -i 's/\(newIP=\)\(.*\)/\1'"$iam_ip_addr"'/g' ../dynafed/assets/replace_iam_ip.sh
        
        if [ -f ../ui/assets/usercert/usercert.pem ]; then
            cat ../iam/assets/certs/digicert/DigiCertAssuredIDRootCA.crt ../iam/assets/certs/digicert/TERENAeSciencePersonalCA3.pem ../ui/assets/usercert/usercert.pem > ../dynafed/assets/certs/Fullchain.pem
        else
            printf '\nWarning: could not find x509 cert, user VOMS proxy will be rejected by DynaFed!\n'
        fi

        if [ -f grid-mapfile ]; then
            cat grid-mapfile >> ../dynafed/assets/grid-mapfile
            printf '\ndynafed service successfully configured!\n'
            printf '\nYou can contact dynafed at the following URL: https://%s:%s/myfed/indigo-dc\n' "$HOSTNAME" "$dynafed_port"
        else
            printf '\nWarning: ui service not yet configured, could not add user to grid-mapfile!\n'
        fi
        ;;

      *)
        printf '\nUnknown service. Exit.\n'
        ;;
    esac
else
    printf '\nService not set. Exit.\n'
    exit 1
fi
