FROM centos:7

ENV UID=1001

COPY assets/yum.repos.d/egi-ca.repo /etc/yum.repos.d/

RUN yum install -y epel-release

RUN yum install -y \
    sudo \
    xauth \
    which \
    wget \
    mesa-libGL \
    dbus-x11 \
    firefox \
    bind-utils \
    jq \
    expect \
    ca-policy-egi-core \
    fetch-crl \
    sharutils

RUN yum install -y https://github.com/indigo-dc/oidc-agent/releases/download/v3.1.1/oidc-agent-3.1.1-1.x86_64.rpm
    
RUN for f in `find /etc/grid-security/certificates -type f -name '*.pem'`; do sudo cp $f /etc/pki/ca-trust/source/anchors/; done
RUN update-ca-trust

RUN groupadd -g $UID storm
RUN useradd -u $UID -g $UID -ms /bin/bash storm 

COPY assets/scripts/ /home/storm/scripts/

RUN echo "storm ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/storm && \
    chmod 0440 /etc/sudoers.d/storm

RUN chown -R storm:storm /home/storm/

USER storm

RUN /home/storm/scripts/install-xdg-utils.sh

CMD /home/storm/scripts/replace_iam_ip.sh $HOSTNAME && \
    /home/storm/scripts/set_xauth_list.sh && /bin/bash
