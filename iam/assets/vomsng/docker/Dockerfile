FROM ffornari/http-storage-demo-cnaf:voms-aa

RUN apt-get update -y && apt-get install -y ca-certificates curl nano && apt-get clean all

COPY iam/assets/certs/digicert/Fullchain.pem /usr/local/share/ca-certificates/Fullchain.crt
COPY iam/assets/certs/digicert/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY iam/assets/trust-anchors/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt

RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y

RUN mkdir -p /etc/grid-security/voms

COPY certs/hostcert.pem /etc/grid-security/voms/hostcert.pem
COPY certs/hostkey.pem /etc/grid-security/voms/hostkey.pem

EXPOSE 15000
