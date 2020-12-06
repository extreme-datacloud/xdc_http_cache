FROM centos:7

ENV UID=

RUN yum install epel-release -y

COPY assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl sharutils -y
RUN yum install vim telnet screen expect xauth dbus-x11 firefox -y
RUN yum -y install redhat-lsb-core wget git tar
RUN yum install -y xmlto && \
    wget https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz && \
    tar xzvf xdg-utils-1.1.2.tar.gz && \
    cd xdg-utils-1.1.2 && \
    ./configure --prefix="/usr/local" && \
    make && \
    make install && \
    cd .. && \
    rm -rf xdg-utils-1.1.2*

RUN yum -y install yum-utils gfal2-all davix attr acl jq voms-clients-java  && \
    yum -y install https://github.com/indigo-dc/oidc-agent/releases/download/v3.1.1/oidc-agent-3.1.1-1.x86_64.rpm

RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do cp $f /etc/pki/ca-trust/source/anchors/; done
COPY assets/vomsdir /etc/grid-security/vomsdir
COPY assets/vomses /etc/vomses

RUN update-ca-trust

RUN groupadd -g $UID storm
RUN useradd -u $UID -g $UID -ms /bin/bash storm

COPY assets/scripts/ /home/storm/scripts/
RUN sed -i 's/..\/ui\/assets\/scripts\/oidc_expect.sh/.\/oidc_expect.sh/g' /home/storm/scripts/oidc_get_token.sh
COPY assets/usercert/usercred.p12 /home/storm/usercred.p12
COPY assets/usercert/usercred.p12 /home/storm/.globus/usercred.p12
COPY assets/oidc-agent/ /home/storm/.oidc-agent/

RUN chown -R storm:storm /home/storm/

COPY assets/scripts/voms-proxy-init_overload.sh /

RUN /voms-proxy-init_overload.sh

USER storm

RUN chmod 600 /home/storm/.globus/usercred.p12 && \
    chmod 600 /home/storm/usercred.p12

CMD /home/storm/scripts/set_xauth_list.sh && /bin/bash
