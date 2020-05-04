FROM openjdk:8

RUN mkdir /indigo-iam

WORKDIR /indigo-iam

COPY assets/iam-be/iam-login-service.war /indigo-iam/
COPY assets/iam-nginx/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY assets/iam-nginx/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt
COPY assets/iam-be/wait-for-it.sh /indigo-iam/

RUN chown root:root /indigo-iam/wait-for-it.sh
RUN chmod 755 /indigo-iam/wait-for-it.sh


RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y

RUN mkdir iam-login-service && \
    cd iam-login-service && \
    jar xf ../iam-login-service.war && \
    cd .. && \
    sed -i 's/trustAnchorsDir: ${IAM_X509_TRUST_ANCHORS_DIR:\/etc\/grid-security\/certificates}/trustAnchorsDir: ${IAM_X509_TRUST_ANCHORS_DIR:\/etc\/ssl\/certs}/g' \
        iam-login-service/WEB-INF/classes/application.yml && \
    sed -i \
    's/    url: jdbc:mysql:\/\/${IAM_DB_HOST:dev.local.io}:${IAM_DB_PORT:3306}\/${IAM_DB_NAME:iam}/\
    url: jdbc:mysql:\/\/${IAM_DB_HOST:iam.local.io}:${IAM_DB_PORT:3306}\/${IAM_DB_NAME:iam}?serverTimezone=UTC/g' \
        iam-login-service/WEB-INF/classes/application-mysql.yml && \
    sed -i 's/  jpa:/  #jpa:/g' iam-login-service/WEB-INF/classes/application.yml && \
    sed -n '18,34p' iam-login-service/WEB-INF/classes/application-mysql.yml > tmp.yml && echo " " >> tmp.yml && \
    sed -i "35r tmp.yml" iam-login-service/WEB-INF/classes/application.yml && rm -f tmp.yml && \
    rm -f iam-login-service.war && \
    jar -cvf0m iam-login-service.war iam-login-service/META-INF/MANIFEST.MF -C iam-login-service .

CMD \
    ./wait-for-it.sh -t 0 db.example:3306 && \
    java -XX:MaxRAMFraction=1 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap ${IAM_JAVA_OPTS} -jar iam-login-service.war
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
