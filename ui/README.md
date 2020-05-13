# User interface
The user interface container provides the utilities to create a VOMS proxy (voms-clients-java) or request a token (oidc-agent).
Service configuration can be done moving to `xdc_http_cache/scripts`, running `configure_services.sh`, selecting ui and following the instructions provided by the script.
In order for VOMS authentication to work, the user x509 certificate and the corresponding private key (together with a .p12 format certificate) must be put in `xdc_http_cache/ui/assets/usercert`.
Required files are :
  - usercert.pem
  - userkey.pem
  - user.p12

The .p12 certificate has to be imported in the browser, allowing the user to link the x509 certificate to his IAM account. 
Notice that the certificate must be issued by [TERENA eScience Personal CA 3](https://www.digicert.com/digicert-root-community-certificates.htm) for the services to work.
The configuration files for the VO to be configured should be provided under the `vomses` and `vomsdir` folders. These folders contain reference example files, properly configurable by running `xdc_http_cache/scripts/configure_services.sh`.
Since you have to open a browser from inside the docker container (required for IAM account or token exchange client registration with `oidc-agent`), in order to start the ui service just run `xdc_http_cache/ui/connect_ui.sh`:
```
./connect_ui.sh
```
A VOMS proxy can be requested using the command:
```
voms-proxy-init --voms <vo name>
```
while a token can be requested using the following commands:
```
eval `oidc-agent`
export CLIENT=<registered client>
oidc-add $CLIENT
export SUBJECT_TOKEN=$(oidc-token $CLIENT)
```
In order to request a token a client must be registered in the selected IAM (the OIDC provider choosen for this deployment). For this we invite to refer  to the documentation:
[IAM documentation](https://indigo-iam.github.io/docs/v/current/)

With the VOMS proxy or the token then HTTP requests can be be made using `curl` or `davix`. A few usage examples is reported:

```
curl -v -s --capath /digicert \
     -L https://<hostname>:<port>/<path> \
     -o /tmp/<path> \
     -H "Authorization: Bearer ${SUBJECT_TOKEN}"

davix-get  -H "Authorization: Bearer ${SUBJECT_TOKEN}"   https://<hostname>:<port>/<path>

davix-put -P grid <file>  https://<hostname>:<port>/<path>
```
For a complete documentation we refere to:
[curl](https://curl.haxx.se/)
[davix](https://dmc.web.cern.ch/projects/davix/home)

