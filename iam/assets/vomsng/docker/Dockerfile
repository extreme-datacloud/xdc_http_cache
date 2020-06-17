FROM extremedatacloud/xdc-http-cache-vomsaa:latest

RUN apt-get update -y && apt-get install -y ca-certificates curl nano && apt-get clean all

RUN for f in `find /usr/share/ca-certificates/mozilla/ -type f -name '*.crt'`; do cp $f /usr/local/share/ca-certificates/; done
RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y

RUN mkdir -p /etc/grid-security/voms

COPY certs/hostcert.pem /etc/grid-security/voms/hostcert.pem
COPY certs/hostkey.pem /etc/grid-security/voms/hostkey.pem

EXPOSE 15000
