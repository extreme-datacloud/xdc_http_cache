FROM nginx:latest
COPY assets/iam-nginx/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
RUN apt-get update && apt-get install -y ca-certificates curl nano && apt-get clean all
COPY assets/iam-nginx/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY assets/iam-nginx/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt
COPY assets/iam-nginx/nginx.conf /etc/nginx/
COPY assets/iam-nginx/iam.conf /etc/nginx/conf.d/default.conf
COPY assets/iam-nginx/iam.key.pem /etc/ssl/private/
COPY assets/iam-nginx/iam.cert.pem /etc/ssl/certs/
RUN mkdir -p /usr/share/man/man1
RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y
