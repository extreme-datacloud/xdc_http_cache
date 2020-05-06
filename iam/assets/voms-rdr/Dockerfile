FROM nginx:latest
EXPOSE 9443
COPY iam/assets/iam-nginx/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
RUN apt-get update && apt-get install -y ca-certificates curl nano && apt-get clean all
COPY iam/assets/certs/digicert/Fullchain.pem /usr/local/share/ca-certificates/Fullchain.crt
COPY iam/assets/certs/digicert/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY iam/assets/trust-anchors/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt
COPY iam/assets/voms-rdr/nginx.conf /etc/nginx/
COPY iam/assets/voms-rdr/voms.conf /etc/nginx/conf.d/default.conf
COPY certs/hostkey.pem /etc/ssl/private/
COPY certs/hostcert.pem /etc/ssl/certs/
RUN mkdir -p /usr/share/man/man1
RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y
