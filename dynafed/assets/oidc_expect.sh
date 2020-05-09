#!/usr/bin/expect
set CLIENT {}
set PASSWORD {}
spawn oidc-add $CLIENT
expect "Enter decryption password for account config '$CLIENT': " \
       {send "$PASSWORD\n"}
expect eof
