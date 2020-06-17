FROM centos:7

RUN yum install epel-release centos-release-scl -y

RUN yum install wget \
        git \
	gcc-c++ \
        cmake3 \
        pcre-devel \
        openssl-devel \
        zlib-devel \
        libxslt-devel \
        gd-devel \
        geoip-devel \
        boost-devel \
        rh-python36 \
        libmaxminddb-devel \
        memcached \
        libmemcached-devel \
        protobuf-devel \
        davix \
        davix-devel \
        gfal2-util \
        gfal2-devel \
        python-devel \
        dmlite-devel \
        python3-devel \
        python3-libs \
        httpd-devel \
        doxygen \
        graphviz \
        cppunit-devel \
        curl-devel \
        boost-python \
        gsoap-devel \
        jansson-devel \
        libbsd-devel \
        gridsite-devel \
        globus-gridftp-server-devel \
        -y

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install devtoolset-7-gcc \
        devtoolset-7-binutils \
        devtoolset-7-gcc-c++ \
        json-c-devel \
        voms-devel \
        mysql-devel \
        -y

RUN source /opt/rh/devtoolset-7/enable && \
    source /opt/rh/rh-python36/enable && \
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/rh/rh-python36/root/usr/include/python3.6m && \
    wget https://sourceforge.net/projects/boost/files/boost/1.67.0/boost_1_67_0.tar.gz && \
    tar xzvf boost_1_67_0.tar.gz && \
    rm -f boost_1_67_0.tar.gz && \
    mv boost_1_67_0/ boost && \
    cd boost && \
    ./bootstrap.sh && \
    ./b2 install --with=all && \
    cd .. && \
    ln -s /usr/local/lib/libboost_python36.so /usr/local/libboost_python3.so && \
    ln -s /usr/local/lib/libboost_python36.so /usr/local/lib/libboost_python3.so && \
    ln -s /usr/lib64/libboost_python.so.1.53.0 /usr/local/libboost_python.so && \
    ln -s /usr/lib64/libboost_python.so.1.53.0 /usr/local/lib/libboost_python.so && \
    git clone https://gitlab.cern.ch/lcgdm/lcgdm-dav.git && \
    cd lcgdm-dav && \
    ./buildcurl.sh && \
    mkdir build && \
    cd build && \
    cmake3 -G "Unix Makefiles" .. && \
    gmake && \
    gmake install && \
    cd ../.. && \
    git clone https://gitlab.cern.ch/lcgdm/dmlite.git && \
    cd dmlite && \
    mkdir build && \
    cd build && \
    mkdir -p doc/html && \
    mkdir doc/man && \
    cmake3 -G "Unix Makefiles" .. && \
    gmake && \
    gmake install && \
    cd ../.. && \
    git clone https://gitlab.cern.ch/lcgdm/dynafed.git && \
    cd dynafed && \
printf '\nvoid UgrConfig::ArrayGetHeaderString \
\n(const char *name, std::string &val, int pos) { \
\n  if (val.empty()) return; \
\n  if (arrdata.find(name) == arrdata.end()) { \
\n    val = ""; \
\n    return; \
\n  } \
\n  else { \
\n    if (pos >= (int)arrdata[name].size()) { \
\n      val = ""; \
\n      return; \
\n    } \
\n    val = arrdata[name][pos]; \
\n  } \
\n}' >> src/UgrConfig.cc && \
sed -i "115s/.*/    void ArrayGetHeaderString(const char *name, std::string \&val, int pos);/" src/UgrConfig.hh && \
sed -i "195s/.*/    std::string s = \" \";/" src/plugins/httpclient/UgrLocPlugin_http.cc && \
sed -i "s/        UgrCFG->ArrayGetString(ss.str().c_str(), s, p++);/        UgrCFG->ArrayGetHeaderString(ss.str().c_str(), s, p++);/g" \
    src/plugins/httpclient/UgrLocPlugin_http.cc && \
sed -i "s/        if (s) {/        if (\!s.empty()) {/g" src/plugins/httpclient/UgrLocPlugin_http.cc && \
mkdir build && \
cd build && \
cmake3 -G "Unix Makefiles" .. && \
gmake && \
gmake install
