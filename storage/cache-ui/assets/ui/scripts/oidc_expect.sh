#!/usr/bin/expect
set CLIENT {test-local}
set PASSWORD {test-local}
spawn oidc-add $CLIENT
expect "Enter decryption password for account config '$CLIENT': " {send "$PASSWORD\n"}
expect eof

