FROM centos:7

RUN yum install epel-release centos-release-scl -y

RUN yum install wget \
        make \
        git \
        gcc-c++ \
        pcre-devel \
        openssl-devel \
        zlib-devel \
        libxslt-devel \
        gd-devel \
        geoip-devel \
        voms-devel \
        rh-python36 \
        -y

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install devtoolset-7-gcc \
        devtoolset-7-binutils \
        devtoolset-7-gcc-c++ \
        -y

RUN source /opt/rh/devtoolset-7/enable && \
    source /opt/rh/rh-python36/enable && \
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/rh/rh-python36/root/usr/include/python3.6m && \
    wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar xzvf boost_1_67_0.tar.gz && \
    rm -f boost_1_67_0.tar.gz && \
    mv boost_1_67_0/ boost && \
    cd boost && \
    ./bootstrap.sh && \
    ./b2 install --with=all && \
    cd .. && \
    wget https://openresty.org/download/openresty-1.15.8.2.tar.gz && \
    tar xzvf openresty-1.15.8.2.tar.gz && rm -f openresty-1.15.8.2.tar.gz && \
    mv openresty-1.15.8.2/ openresty && \
    git clone https://baltig.infn.it/storm2/ngx_http_voms_module.git && \
    cd openresty && \
    ./configure \
    --with-cc-opt='-g -O3' \
    --add-module=../ngx_http_voms_module \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-threads \
    && gmake \
    && gmake install
