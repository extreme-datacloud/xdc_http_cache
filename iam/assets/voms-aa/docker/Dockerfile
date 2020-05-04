FROM indigoiam/voms-aa

RUN apt-get update -y && apt-get install -y ca-certificates curl nano && apt-get clean all

COPY assets/certs/digicert/Fullchain.pem /usr/local/share/ca-certificates/Fullchain.crt
COPY assets/certs/digicert/FullchainHost.pem /usr/local/share/ca-certificates/FullchainHost.crt
COPY assets/trust-anchors/igi-test-ca.pem /usr/local/share/ca-certificates/igi-test-ca.crt

RUN update-ca-certificates && apt-get update -y && apt-get install ca-certificates-java -y

WORKDIR /voms-aa
    
RUN mkdir -p /etc/grid-security/voms

COPY assets/certs/digicert/cloud-vm159_cloud_cnaf_infn_it.crt /etc/grid-security/voms/hostcert.pem
COPY assets/certs/digicert/cloud-vm159_cloud_cnaf_infn_it.key /etc/grid-security/voms/hostkey.pem
COPY assets/certs/digicert/cloud-vm159_cloud_cnaf_infn_it.p12 /etc/grid-security/voms/keystore.p12

EXPOSE 15000

RUN mkdir voms-aa && \
    cd voms-aa && \
    jar xf ../voms-aa.jar && \
    cd .. && \
    sed -i \
's/    url: jdbc:mysql:\/\/${IAM_DB_HOST:dev.local.io}:${IAM_DB_PORT:3306}\/${IAM_DB_NAME:iam}/\
    url: jdbc:mysql:\/\/${IAM_DB_HOST:db}:${IAM_DB_PORT:3306}\/${IAM_DB_NAME:iam}?serverTimezone=UTC/g' \
        voms-aa/BOOT-INF/classes/application-mysql.yml && \
    sed -i 's/  flyway:/  #flyway:/g'  voms-aa/BOOT-INF/classes/application.yml && \
    sed -i 's/    locations:/    #locations:/g'  voms-aa/BOOT-INF/classes/application.yml && \
    sed -i 's/    - classpath:db\/migration\/test/    #- classpath:db\/migration\/test/g' \
         voms-aa/BOOT-INF/classes/application.yml && \
    sed -i 's/    - classpath:db\/migration\/h2/    #- classpath:db\/migration\/mysql/g' \
         voms-aa/BOOT-INF/classes/application.yml && \
#    sed -i 's/    max-active: ${IAM_DB_MAX_ACTIVE:100}/    max-active: ${IAM_DB_MAX_ACTIVE:50}/g' \
#        voms-aa/BOOT-INF/classes/application-mysql.yml && \
    sed -n '18,34p' voms-aa/BOOT-INF/classes/application-mysql.yml > tmp.yml && \
    echo " " >> tmp.yml && \
    sed -i "26r tmp.yml" voms-aa/BOOT-INF/classes/application.yml && \
#    sed -i 's/logging.level.root=WARN/logging.level.root=DEBUG/g' \
#        voms-aa/BOOT-INF/classes/application.properties && \
    sed -i 's/  address: localhost/  address: cloud-vm159.cloud.cnaf.infn.it/g' \
        voms-aa/BOOT-INF/classes/application.yml && \
    sed -i 's/    vo-name: test/    vo-name: indigo-dc/g' \
        voms-aa/BOOT-INF/classes/application.yml && \
    sed -i 's/    trust-anchors-dir: \/etc\/grid-security\/certificates/    trust-anchors-dir: \/etc\/ssl\/certs/g' \
        voms-aa/BOOT-INF/classes/application.yml && \
#    echo '\n    max-ac-lifetime-in-seconds: 86400' >> voms-aa/BOOT-INF/classes/application.yml && \
    rm -f tmp.yml && \
printf '  ssl: \
\n    key-store: /etc/grid-security/voms/keystore.p12 \
\n    key-store-type: pkcs12 \
\n    key-store-password: iam_test_ssl_cert\n' > tmp.yml && \
    sed -i "18r tmp.yml" voms-aa/BOOT-INF/classes/application.yml && \
    rm -f tmp.yml voms-aa.jar && \
    jar -cvf0m voms-aa.jar voms-aa/META-INF/MANIFEST.MF -C voms-aa .

CMD java -jar voms-aa.jar
