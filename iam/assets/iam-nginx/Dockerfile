FROM nginx:latest
COPY iam/assets/iam-nginx/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
RUN apt-get update && apt-get install -y ca-certificates curl nano && apt-get clean all
RUN for f in `find /usr/share/ca-certificates/mozilla/ -type f -name '*.crt'`; do cp $f /usr/local/share/ca-certificates/; done
COPY iam/assets/iam-nginx/nginx.conf /etc/nginx/
COPY iam/assets/iam-nginx/iam.conf /etc/nginx/conf.d/default.conf
COPY certs/hostkey.pem /etc/ssl/private/
COPY certs/hostcert.pem /etc/ssl/certs/
RUN mkdir -p /usr/share/man/man1
RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y
