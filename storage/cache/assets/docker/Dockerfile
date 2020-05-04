FROM ffornari/http-storage-demo-cnaf:nginx_voms_centos7

ENV PATH="/usr/local/openresty/bin:${PATH}"
ENV LD_PRELOAD="/usr/local/lib/libopenssl_evp_redefine.so"

WORKDIR work/

COPY assets/certs/digicert/ /digicert/
COPY assets/vomsdir/ /vomsdir/
COPY assets/certs/digicert/Fullchain.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/FullchainProxy.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
COPY assets/trust-anchors/igi-test-ca.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/FullchainProxy.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY assets/trust-anchors/igi-test-ca.pem /etc/pki/ca-trust/source/anchors/

COPY assets/docker/libopenssl_evp_redefine.so /usr/local/lib/

RUN opm get zmartzone/lua-resty-openidc

RUN mkdir logs && mkdir conf && mkdir -p /data/nginx/cache

#COPY assets/docker/nginx_voms_token_webdav_cache_1.conf ./conf/nginx.conf
#COPY assets/docker/nginx_voms_token_webdav_cache_2.conf ./conf/nginx.conf
#COPY assets/docker/mime.types ./conf/mime.types

EXPOSE 13443

STOPSIGNAL SIGTERM

RUN update-ca-trust

CMD /usr/local/openresty/nginx/sbin/nginx -p ./ -c conf/nginx.conf -g 'daemon off;'
