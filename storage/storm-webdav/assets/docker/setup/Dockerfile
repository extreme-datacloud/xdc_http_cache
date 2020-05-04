FROM italiangrid/storm-webdav-centos7:latest

USER root

#RUN rm -f /var/lib/rpm/__*
#RUN rpm --rebuilddb -v -v

#COPY ./assets/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf

COPY ./assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
COPY ./assets/trust-anchors /trust-anchors

RUN yum install ca-policy-egi-core fetch-crl -y

USER storm

ENTRYPOINT ["/scripts/setup.sh"]
