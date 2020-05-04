FROM centos:7
RUN yum install epel-release -y

COPY assets/ui/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl sharutils -y
RUN yum install vim telnet screen expect spawn -y

COPY assets/ui/certs/digicert/Fullchain.pem /etc/grid-security/certificates/
COPY assets/ui/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
COPY assets/ui/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/
COPY assets/ui/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY assets/ui/certs/digicert/TERENAeSciencePersonalCA3.pem /etc/grid-security/certificates/
COPY assets/ui/certs/digicert/TERENAeSciencePersonalCA3.pem /etc/pki/ca-trust/source/anchors/
COPY assets/ui/certs/digicert/TERENAPersonalCA3.crt /etc/pki/ca-trust/source/anchors/
COPY assets/ui/certs/digicert/TERENAPersonalCA3.crt /etc/grid-security/certificates/

RUN update-ca-trust

RUN groupadd -g 1001 storm
RUN useradd -u 1001 -g 1001  -ms /bin/bash storm

RUN mkdir /home/storm/scripts && chown -R storm:storm /home/storm/scripts

RUN \
  yum -y install redhat-lsb-core wget git tar && \
  yum -y update && \
  yum -y install yum-utils gfal2-all davix attr acl jq voms-clients-java  && \
  yum -y install http://repo.indigo-datacloud.eu/repository/deep-hdc/production/1/centos7/x86_64/third-party/oidc-agent-3.1.1-1.x86_64.rpm

RUN chown -R storm:storm /home/storm/

USER storm
