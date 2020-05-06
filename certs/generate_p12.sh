#!/usr/bin/expect
set COMMAND {openssl pkcs12 -export -in hostcert.pem -inkey hostkey.pem -out keystore.p12 -certfile DigiCertCA.crt}
set PASSWORD {voms_aa_ssl_cert}
eval spawn $COMMAND
expect "Enter Export Password:" {send "$PASSWORD\n"}
expect "Verifying - Enter Export Password:" {send "$PASSWORD\n"}
expect eof
