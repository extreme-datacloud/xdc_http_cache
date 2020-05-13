FROM italiangrid/storm-webdav-centos7:latest

USER root

COPY certs/hostcert.pem /certs/
COPY certs/hostkey.pem /certs/
COPY storage/storm-webdav/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo

RUN yum install ca-policy-egi-core fetch-crl -y

USER storm

ENTRYPOINT ["/scripts/setup.sh"]
