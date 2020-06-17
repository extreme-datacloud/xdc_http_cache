FROM storm2/ngx-voms:latest
EXPOSE 443

COPY ui/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl sharutils -y

RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do cp $f /etc/pki/ca-trust/source/anchors/; done
RUN update-ca-trust

COPY certs/hostcert.pem /certs/
COPY certs/hostkey.pem /certs/
