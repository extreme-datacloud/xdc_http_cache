FROM italiangrid/storm-webdav-centos7:latest

ENV IAM_HOSTNAME=

USER root

RUN yum install -y java-1.8.0-openjdk-devel

COPY storage/storm-webdav/assets/certs/digicert/Fullchain.pem /etc/pki/ca-trust/source/anchors/Fullchain.pem
COPY storage/storm-webdav/assets/certs/digicert/FullchainHost.pem /etc/pki/ca-trust/source/anchors/FullchainHost.pem
COPY storage/storm-webdav/assets/certs/sectigo/FullchainHostSectigo.pem /etc/pki/ca-trust/source/anchors/FullchainHostSectigo.pem

COPY storage/storm-webdav/assets/etc/sysconfig/storm-webdav /etc/sysconfig/storm-webdav

RUN chown storm.storm -R /etc/pki && \
    mkdir storm-webdav-server && \
    cd storm-webdav-server && \
    jar xf /usr/share/java/storm-webdav/storm-webdav-server.jar && \
    cd .. && \
    sed -i 's/    enabled: \${STORM_WEBDAV_VO_MAP_FILES_ENABLE:false}/    enabled: \${STORM_WEBDAV_VO_MAP_FILES_ENABLE:true}/g' \
        storm-webdav-server/BOOT-INF/classes/application.yml && \
    #sed -i 's/#logging.level.org.springframework.security=DEBUG/logging.level.org.springframework.security=DEBUG/g' \
    #   storm-webdav-server/BOOT-INF/classes/application.properties && \
    rm -f /usr/share/java/storm-webdav/storm-webdav-server.jar && \
    jar -cvf0m /usr/share/java/storm-webdav/storm-webdav-server.jar \
    storm-webdav-server/META-INF/MANIFEST.MF -C storm-webdav-server .

CMD /home/storm/replace_iam_ip.sh $IAM_HOSTNAME && /run.sh
