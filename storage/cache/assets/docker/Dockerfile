FROM ffornari/http-storage-demo-cnaf:nginx_voms_centos7

ENV PATH="/usr/local/openresty/bin:${PATH}"
ENV LD_PRELOAD="/usr/local/lib/libopenssl_evp_redefine.so"

WORKDIR work/

COPY assets/certs/hostcert/ /hostcert/
COPY assets/vomsdir/ /vomsdir/

COPY assets/docker/libopenssl_evp_redefine.so /usr/local/lib/

RUN opm get zmartzone/lua-resty-openidc

RUN mkdir logs && mkdir conf && mkdir -p /data/nginx/cache

EXPOSE 13443

STOPSIGNAL SIGTERM

RUN update-ca-trust

CMD /usr/local/openresty/nginx/sbin/nginx -p ./ -c conf/nginx.conf -g 'daemon off;'
