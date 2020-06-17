FROM italiangrid/storm-webdav-centos7:latest

USER root

COPY certs/hostcert.pem /certs/
COPY certs/hostkey.pem /certs/
COPY storage/storm-webdav/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo

RUN yum install ca-policy-egi-core fetch-crl -y

RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do cp $f /etc/pki/ca-trust/source/anchors/; done

USER storm

ENTRYPOINT ["/scripts/setup.sh"]
