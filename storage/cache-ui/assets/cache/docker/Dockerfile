FROM ffornari/http-storage-demo-cnaf:nginx_voms_centos7

ENV PATH="/usr/local/openresty/bin:${PATH}"
ENV LD_PRELOAD="/usr/local/lib/libopenssl_evp_redefine.so"

WORKDIR work/

COPY assets/cache/certs/digicert/ /digicert/
COPY assets/cache/vomsdir/ /vomsdir/
COPY assets/cache/certs/digicert/Fullchain.pem /etc/grid-security/certificates/
COPY assets/cache/certs/digicert/FullchainProxy.pem /etc/grid-security/certificates/
COPY assets/cache/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
COPY assets/cache/trust-anchors/igi-test-ca.pem /etc/grid-security/certificates/
COPY assets/cache/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/
COPY assets/cache/certs/digicert/FullchainProxy.pem /etc/pki/ca-trust/source/anchors/
COPY assets/cache/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY assets/cache/trust-anchors/igi-test-ca.pem /etc/pki/ca-trust/source/anchors/

COPY assets/cache/docker/libopenssl_evp_redefine.so /usr/local/lib/

RUN opm get zmartzone/lua-resty-openidc

RUN mkdir logs && mkdir conf && mkdir -p /data/nginx/cache

EXPOSE 13443

STOPSIGNAL SIGTERM

RUN update-ca-trust

CMD /usr/local/openresty/nginx/sbin/nginx -p ./ -c conf/nginx.conf -g 'daemon off;'
