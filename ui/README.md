# User interface
The user interface container provides the utilities to create a VOMS proxy (voms-clients-java) or request a token (oidc-agent).
The user interface can be deployed with the following commands:
```
docker-compose build # first time
docker-compose up -d
```
In order to work few modification must be done on the docker-compose.yml file. The location of the user x509 certificate and the corresponding private key must be provided. The corresponding configuration file for the VO to be configured must be provided under the `vomses` and `vomsdir` folders. These folders contain reference example files.
When the user interface is up it is possible to login with:
```
docker exec -it <ui container id> /bin/bash
```
A VOMS proxy can requested using the command:
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
