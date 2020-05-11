FROM ffornari/http-storage-demo-cnaf:nginx_voms_centos7

ENV IAM_HOSTNAME=
ENV PATH="/usr/local/openresty/bin:${PATH}"
ENV LD_PRELOAD="/usr/local/lib/libopenssl_evp_redefine.so"

WORKDIR work/

COPY certs/ /hostcert/
COPY storage/cache/assets/vomsdir/ /vomsdir/
COPY storage/cache/assets/trust-anchors/FullchainHost.pem /etc/grid-security/certificates/
COPY storage/cache/assets/trust-anchors/FullchainHost.pem /etc/pki/ca-trust/source/anchors/

COPY storage/cache/assets/docker/libopenssl_evp_redefine.so /usr/local/lib/

RUN opm get zmartzone/lua-resty-openidc

RUN mkdir logs && mkdir conf && mkdir -p /data/nginx/cache

EXPOSE 13443

STOPSIGNAL SIGTERM

RUN update-ca-trust

CMD /work/replace_iam_ip.sh $IAM_HOSTNAME && \
    /usr/local/openresty/nginx/sbin/nginx -p ./ -c conf/nginx.conf -g 'daemon off;'
