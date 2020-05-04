FROM nginx:latest
EXPOSE 9443
COPY assets/iam-nginx/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
RUN apt-get update && apt-get install -y ca-certificates curl nano && apt-get clean all
COPY assets/certs/digicert/Fullchain.pem /usr/local/share/ca-certificates/Fullchain.crt
COPY assets/certs/digicert/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY assets/trust-anchors/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt
COPY assets/voms-rdr/nginx.conf /etc/nginx/
COPY assets/voms-rdr/voms.conf /etc/nginx/conf.d/default.conf
COPY assets/certs/digicert/cloud-vm159_cloud_cnaf_infn_it.key /etc/ssl/private/
COPY assets/certs/digicert/cloud-vm159_cloud_cnaf_infn_it.crt /etc/ssl/certs/
RUN mkdir -p /usr/share/man/man1
RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y
