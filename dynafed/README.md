#CAVEATS

Dynafed needs to be configured, so go to xdc_http_cache/scripts and run configure_dynafed.sh.
You will be required to create an IAM account and a token exchange client for Dynafed.
Then you will have to provide the following infos:

- IAM hostname
- Dynafed token client id
- Dynafed token client secret
- Dynafed token client passphrase
- Dynafed IAM account username
- Dynafed IAM account password

Finally, before starting Dynafed, you will need to properly configure file xdc_http_cache/dynafed/assets/endpoints.conf.
