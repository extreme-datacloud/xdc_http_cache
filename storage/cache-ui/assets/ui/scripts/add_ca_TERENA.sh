#!/bin/bash
cd /etc/grid-security/certificates/ && ln -s TERENAPersonalCA3Full.crt  `openssl x509 -noout -hash -in TERENAPersonalCA3Full.crt`.0
HASH=`openssl x509 -noout -hash -in TERENAPersonalCA3Full.crt`

cat >$HASH.signing_policy <<EOF
access_id_CA X509 '`openssl x509 -subject -noout -in TERENAPersonalCA3Full.crt | cut -d' ' -f2-`'
pos_rights globus CA:sign
cond_subjects globus '"*"'
EOF
chmod 444 $HASH.signing_policy

echo "http://crl3.digicert.com/TERENAPersonalCA3.crl" >>  TERENAPersonalCA3Full.crl_url
