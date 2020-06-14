FROM storm2/ngx-voms:latest
EXPOSE 443

COPY ui/assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/egi-ca.repo
RUN yum install ca-policy-egi-core fetch-crl sharutils -y

COPY iam/assets/certs/digicert/Fullchain.pem /etc/grid-security/certificates/
COPY iam/assets/certs/digicert/FullchainHost.pem /etc/grid-security/certificates/
COPY iam/assets/certs/sectigo/FullchainHostSectigo.pem /etc/grid-security/certificates/
COPY iam/assets/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/
COPY iam/assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/
COPY iam/assets/certs/sectigo/FullchainHostSectigo.pem /etc/pki/ca-trust/source/anchors/

RUN update-ca-trust

COPY certs/hostcert.pem /certs/
COPY certs/hostkey.pem /certs/
