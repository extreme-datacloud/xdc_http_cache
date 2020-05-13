FROM centos:7

ENV UID=

RUN yum install epel-release -y

COPY assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl sharutils -y
RUN yum install vim telnet screen expect xdg-utils xauth dbus-x11 firefox -y
RUN \
  yum -y install redhat-lsb-core wget git tar && \
  #yum -y update && \
  yum -y install yum-utils gfal2-all davix attr acl jq voms-clients-java  && \
  yum -y install http://repo.indigo-datacloud.eu/repository/deep-hdc/production/1/centos7/x86_64/third-party/oidc-agent-3.1.1-1.x86_64.rpm

COPY assets/certs/digicert/Fullchain.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/TERENAeSciencePersonalCA3.pem /etc/grid-security/certificates/
COPY assets/certs/digicert/TERENAeSciencePersonalCA3.pem /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/TERENAPersonalCA3.crt /etc/pki/ca-trust/source/anchors/
COPY assets/certs/digicert/TERENAPersonalCA3.crt /etc/grid-security/certificates/
COPY assets/certs/digicert /digicert
COPY assets/vomsdir /etc/grid-security/vomsdir
COPY assets/vomses /etc/vomses

RUN update-ca-trust

RUN groupadd -g $UID storm
RUN useradd -u $UID -g $UID -ms /bin/bash storm

COPY assets/scripts/ /home/storm/scripts/
COPY assets/usercert/usercert.pem /home/storm/.globus/usercert.pem
COPY assets/usercert/userkey.pem /home/storm/.globus/userkey.pem
COPY assets/usercert/user.p12 /home/storm/usercred.p12
COPY assets/oidc-agent/ /home/storm/.oidc-agent/

RUN chown -R storm:storm /home/storm/

USER storm

RUN chmod 400 /home/storm/.globus/userkey.pem && \
    chmod 600 /home/storm/.globus/usercert.pem && \
    /home/storm/scripts/set_xauth_list.sh

CMD /bin/bash
