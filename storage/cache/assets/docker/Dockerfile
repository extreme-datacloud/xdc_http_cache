FROM extremedatacloud/xdc-http-cache-nginx:latest

ENV IAM_HOSTNAME=
ENV PATH="/usr/local/openresty/bin:${PATH}"
ENV LD_PRELOAD="/usr/local/lib/libopenssl_evp_redefine.so"

COPY storage/cache/assets/docker/libopenssl_evp_redefine.so /usr/local/lib/
COPY storage/cache/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl -y

WORKDIR work/

COPY certs/ /hostcert/
COPY storage/cache/assets/vomsdir/ /vomsdir/

RUN opm get zmartzone/lua-resty-openidc

RUN mkdir logs && mkdir conf && mkdir -p /data/nginx/cache

EXPOSE 13443

STOPSIGNAL SIGTERM

RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do cp $f /etc/pki/ca-trust/source/anchors/; done

RUN update-ca-trust

CMD /work/replace_iam_ip.sh $IAM_HOSTNAME && \
    /usr/local/openresty/nginx/sbin/nginx -p ./ -c conf/nginx.conf -g 'daemon off;'
