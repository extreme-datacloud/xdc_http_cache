FROM openjdk:8

RUN mkdir /indigo-iam

WORKDIR /indigo-iam

COPY iam/assets/iam-be/iam-login-service.war /indigo-iam/
COPY iam/assets/iam-nginx/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY iam/assets/iam-nginx/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt
COPY iam/assets/iam-be/wait-for-it.sh /indigo-iam/

RUN chown root:root /indigo-iam/wait-for-it.sh
RUN chmod 755 /indigo-iam/wait-for-it.sh


RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y

RUN mkdir iam-login-service && \
    cd iam-login-service && \
    jar xf ../iam-login-service.war && \
    cd .. && \
    sed -i 's/trustAnchorsDir: ${IAM_X509_TRUST_ANCHORS_DIR:\/etc\/grid-security\/certificates}/trustAnchorsDir: ${IAM_X509_TRUST_ANCHORS_DIR:\/etc\/ssl\/certs}/g' \
        iam-login-service/WEB-INF/classes/application.yml && \
    #export host_old="dev.local.io" && export host_new=$HOSTNAME && \
    #sed -i "s@$(echo $host_old | sed 's/\./\\./g')@$host_new@g" iam-login-service/WEB-INF/classes/application-mysql.yml && \
    sed -i '/${IAM_DB_NAME:iam}/s/$/?serverTimezone=UTC/' iam-login-service/WEB-INF/classes/application-mysql.yml && \
    sed -i 's/  jpa:/  #jpa:/g' iam-login-service/WEB-INF/classes/application.yml && \
    sed -n '18,34p' iam-login-service/WEB-INF/classes/application-mysql.yml > tmp.yml && echo " " >> tmp.yml && \
    sed -i "35r tmp.yml" iam-login-service/WEB-INF/classes/application.yml && rm -f tmp.yml && \
    rm -f iam-login-service.war && \
    jar -cvf0m iam-login-service.war iam-login-service/META-INF/MANIFEST.MF -C iam-login-service .

CMD \
    cd iam-login-service && \
    jar xf ../iam-login-service.war && \
    cd .. && \
    export host_old=$(cat /indigo-iam/iam-login-service/WEB-INF/classes/application-mysql.yml | grep url | awk -F ":" '{print substr($5, 1, length($5)-1)}') && \
    export host_new=$HOSTNAME && \
    sed -i "s@$(echo $host_old | sed 's/\./\\./g')@$host_new@g" iam-login-service/WEB-INF/classes/application.yml && \
    rm -f iam-login-service.war && \
    jar -cvf0m iam-login-service.war iam-login-service/META-INF/MANIFEST.MF -C iam-login-service . 2>&1 > /dev/null && \
    ./wait-for-it.sh -t 0 db.example:3306 && \
    java -XX:MaxRAMFraction=1 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap ${IAM_JAVA_OPTS} -jar iam-login-service.war
    # tail -f /dev/null
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
