FROM ffornari/http-storage-demo-cnaf:dynafed_patched

RUN yum install \
	mod_auth_openidc mod_ssl net-tools geolite2-city jq cronie telnet \
	-y

RUN cd /etc/yum.repos.d/ \
    && wget http://rpms.adiscon.com/v8-stable/rsyslog.repo \
    && yum install rsyslog -y \
    && rm -f /etc/rsyslog.d/listen.conf

RUN yum install edg-mkgridmap php-fpm -y

COPY assets/rsyslog.conf /etc/rsyslog.conf
COPY assets/boost-x86_64.conf /etc/ld.so.conf.d/boost-x86_64.conf
COPY assets/ugr-x86_64.conf /etc/ld.so.conf.d/ugr-x86_64.conf

# do a bit of tuning
# - disable the mod_dav module
# - configure to mpm event for performance
# - add support for memcached docker
RUN sed -i 's/LoadModule dav/#LoadModule dav/g' /etc/httpd/conf/httpd.conf \
  && sed -i 's/Listen 443 /Listen 10443/g' /etc/httpd/conf/httpd.conf \
  && sed -i 's@^#HTTPD=.*@HTTPD=/usr/sbin/httpd.event@g' /etc/sysconfig/httpd \
  && sed -i 's@127.0.0.1:11211@memcache:11211@' /etc/ugr/ugr.conf \
  && sed -i 's/#OIDCProviderMetadataURL <url>/OIDCProviderMetadataURL https:\/\/iam.local.io\/.well-known\/openid-configuration/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCRedirectURI https:\/\/www.example.com\/protected\/redirect_uri/OIDCRedirectURI https:\/\/cloud-vm159.cloud.cnaf.infn.it:10443\/myfed\/redirect_uri/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCSSLValidateServer \[On|Off\]/OIDCSSLValidateServer Off/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCClientID <client_id>/OIDCClientID 686393af-a00a-492d-9d7c-23583741d531/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCClientSecret <client_secret>/OIDCClientSecret AOoxzJI6J9MuI_XByST2VmRVz6VWhHjK20Du_TcYTwDprWi9MWJBjsU52c9ildw-ueFfxmVN9NSQVg0C91JMq0w/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCCryptoPassphrase <passphrase>/OIDCCryptoPassphrase iam_test_ff_90/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/$SystemLogRateLimitInterval 0/# $SystemLogRateLimitInterval 0/g' /etc/rsyslog.d/20-log-dmlite.conf \
  && sed -i 's/#OIDCOAuthClientID <client_id>/OIDCOAuthClientID 686393af-a00a-492d-9d7c-23583741d531/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthClientSecret <client_secret>/OIDCOAuthClientSecret AOoxzJI6J9MuI_XByST2VmRVz6VWhHjK20Du_TcYTwDprWi9MWJBjsU52c9ildw-ueFfxmVN9NSQVg0C91JMq0w/g' \
            /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthVerifyJwksUri <jwks_url>/OIDCOAuthVerifyJwksUri https:\/\/iam.local.io\/jwk/g' /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCIDTokenIatSlack <seconds>/OIDCIDTokenIatSlack 3600/g' /etc/httpd/conf.d/auth_openidc.conf \
  #&& sed -i "264s/.*/OIDCOAuthVerifyCertFiles rsa1#\/iam-keystore.pem/" /etc/httpd/conf.d/auth_openidc.conf \
  #&& sed -i 's/#OIDCOAuthIntrospectionEndpoint <token-introspection-endpoint>/OIDCOAuthIntrospectionEndpoint https:\/\/iam.local.io\/introspect/g' \
  #          /etc/httpd/conf.d/auth_openidc.conf \
  && sed -i 's/#OIDCOAuthSSLValidateServer \[On|Off\]/OIDCOAuthSSLValidateServer Off/g' /etc/httpd/conf.d/auth_openidc.conf

RUN mkdir -p /myfed/indigo-dc
RUN mkdir /myfed/testVO
RUN chown -R apache:apache /myfed

RUN rm -rf /etc/httpd/conf.modules.d/00-dav.conf
RUN rm -rf /etc/httpd/conf.modules.d/00-ssl.conf
RUN rm -rf /etc/httpd/conf.d/zgridsite.conf
RUN rm -rf /etc/httpd/conf.d/zlcgdm-dav.conf
RUN touch /var/log/ugr.log

COPY assets/ugrauth_gridmap.py /etc/ugr/conf.d/ugrauth_gridmap.py
RUN chown apache:apache /etc/ugr/conf.d/ugrauth_gridmap.py
RUN chmod +x /etc/ugr/conf.d/ugrauth_gridmap.py

COPY assets/local_python.sh /etc/profile.d/local_python.sh
COPY assets/startup.sh /startup.sh
COPY assets/certs/FullchainHost.pem /etc/grid-security/certificates
COPY assets/certs/FullchainHostProxy.pem /etc/grid-security/certificates
COPY assets/trust-anchors/igi-test-ca.pem /etc/grid-security/certificates/
COPY assets/certs/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/FullchainHostProxy.pem /etc/pki/ca-trust/source/anchors/
COPY assets/trust-anchors/igi-test-ca.pem /etc/pki/ca-trust/source/anchors/

COPY assets/crontab /var/spool/cron/token_cronjob
RUN chmod 0644 /var/spool/cron/token_cronjob && \
    crontab /var/spool/cron/token_cronjob && \
    update-ca-trust && ldconfig

# expose data bridge ports
EXPOSE 1044
EXPOSE 10443

CMD /usr/sbin/crond && /startup.sh
