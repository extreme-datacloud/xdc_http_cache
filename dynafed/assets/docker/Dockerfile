FROM extremedatacloud/xdc-http-cache-dynafed:latest

ENV IAM_HOSTNAME=
ENV CLIENT_ID=
ENV CLIENT_SECRET=
ENV CLIENT_PASSPHRASE=

COPY dynafed/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl -y

RUN yum install \
	mod_auth_openidc mod_ssl net-tools geolite2-city jq cronie telnet expect \
	-y

RUN cd /etc/yum.repos.d/ \
    && wget http://rpms.adiscon.com/v8-stable/rsyslog.repo \
    && yum install rsyslog -y \
    && rm -f /etc/rsyslog.d/listen.conf \
    && mkdir /digicert

RUN yum install -y https://github.com/indigo-dc/oidc-agent/releases/download/v3.1.1/oidc-agent-3.1.1-1.x86_64.rpm

RUN yum install edg-mkgridmap php-fpm -y

COPY certs/hostcert.pem /digicert/
COPY certs/hostkey.pem /digicert/
COPY dynafed/assets/conf.d/rsyslog.conf /etc/rsyslog.conf
COPY dynafed/assets/conf.d/boost-x86_64.conf /etc/ld.so.conf.d/boost-x86_64.conf
COPY dynafed/assets/conf.d/ugr-x86_64.conf /etc/ld.so.conf.d/ugr-x86_64.conf

# do a bit of tuning
# - disable the mod_dav module
# - configure to mpm event for performance
# - add support for memcached docker
RUN sed -i 's/LoadModule dav/#LoadModule dav/g' /etc/httpd/conf/httpd.conf \
  && sed -i 's/Listen 443 /Listen 10443/g' /etc/httpd/conf/httpd.conf \
  && sed -i 's@^#HTTPD=.*@HTTPD=/usr/sbin/httpd.event@g' /etc/sysconfig/httpd \
  && sed -i 's@127.0.0.1:11211@memcache:11211@' /etc/ugr/ugr.conf \
  && sed -i 's/#OIDCProviderMetadataURL <url>/OIDCProviderMetadataURL https:\/\/iam.local.io\/.well-known\/openid-configuration/g' /etc/httpd/conf.d/auth_openidc.conf \    
  && sed -i 's/#OIDCRedirectURI https:\/\/www.example.com\/protected\/redirect_uri/OIDCRedirectURI https:\/\/iam.local.io:10443\/myfed\/redirect_uri/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCSSLValidateServer \[On|Off\]/OIDCSSLValidateServer Off/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCClientID <client_id>/OIDCClientID client.id/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCClientSecret <client_secret>/OIDCClientSecret client.secret/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCCryptoPassphrase <passphrase>/OIDCCryptoPassphrase client.passphrase/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/$SystemLogRateLimitInterval 0/# $SystemLogRateLimitInterval 0/g' /etc/rsyslog.d/20-log-dmlite.conf \
  && sed -i 's/#OIDCOAuthClientID <client_id>/OIDCOAuthClientID client.id/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthClientSecret <client_secret>/OIDCOAuthClientSecret client.secret/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthVerifyJwksUri <jwks_url>/OIDCOAuthVerifyJwksUri https:\/\/iam.local.io\/jwk/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCIDTokenIatSlack <seconds>/OIDCIDTokenIatSlack 3600/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthSSLValidateServer \[On|Off\]/OIDCOAuthSSLValidateServer Off/g' /etc/httpd/conf.d/auth_openidc.conf \
  && export host_old=iam.local.io \
  && export host_new=$IAM_HOSTNAME \
  && sed -i "s@$(echo $host_old | sed 's/\./\\./g')@$host_new@g" /etc/httpd/conf.d/auth_openidc.conf \
  && export id_old=client.id \
  && export id_new=$CLIENT_ID \
  && sed -i "s@$(echo $id_old | sed 's/\./\\./g')@$id_new@g" /etc/httpd/conf.d/auth_openidc.conf \
  && export secret_old=client.secret \
  && export secret_new=$CLIENT_SECRET \
  && sed -i "s@$(echo $secret_old | sed 's/\./\\./g')@$secret_new@g" /etc/httpd/conf.d/auth_openidc.conf \
  && export passphrase_old=client.passphrase \
  && export passphrase_new=$CLIENT_PASSPHRASE \
  && sed -i "s/$(echo $passphrase_old | sed 's/\./\\./g')/$passphrase_new/g" /etc/httpd/conf.d/auth_openidc.conf

RUN mkdir -p /myfed/indigo-dc
RUN chown -R apache:apache /myfed

RUN rm -rf /etc/httpd/conf.modules.d/00-dav.conf
RUN rm -rf /etc/httpd/conf.modules.d/00-ssl.conf
RUN rm -rf /etc/httpd/conf.d/zgridsite.conf
RUN rm -rf /etc/httpd/conf.d/zlcgdm-dav.conf
RUN touch /var/log/ugr.log

COPY dynafed/assets/scripts/ugrauth_gridmap.py /etc/ugr/conf.d/ugrauth_gridmap.py
RUN chown apache:apache /etc/ugr/conf.d/ugrauth_gridmap.py
RUN chmod +x /etc/ugr/conf.d/ugrauth_gridmap.py

COPY dynafed/assets/scripts/local_python.sh /etc/profile.d/local_python.sh
COPY dynafed/assets/scripts/startup.sh /startup.sh

RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do cp $f /etc/pki/ca-trust/source/anchors/; done

COPY dynafed/assets/scripts/cronjob.sh /cronjob.sh
COPY dynafed/assets/conf.d/crontab /var/spool/cron/token_cronjob
RUN chmod 0644 /var/spool/cron/token_cronjob && \
    crontab /var/spool/cron/token_cronjob && \
    update-ca-trust && ldconfig

# expose data bridge ports
EXPOSE 1044
EXPOSE 10443

CMD /replace_iam_ip.sh $IAM_HOSTNAME && \
    eval `oidc-agent -g | grep -v Agent > /etc/profile.d/oidc-agent.sh` && \
    /usr/sbin/crond && /startup.sh
