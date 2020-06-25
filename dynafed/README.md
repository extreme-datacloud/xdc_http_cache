# Dynafed
The Dynafed container provides a service capable of federating multiple remote storage areas.
Dynafed's authentication against the remote endpoints is managed via token exchange through IAM.
To register an account and a token exchange client for Dynafed on IAM, you must go to `xdc_http_cache/scripts`, run the script `configure_services.sh` selecting Dynafed service, and follow the instructions provided by the script.
Before running `configure_services.sh` for Dynafed, it is recommended to start iam service in a `screen` session with docker-compose without daemonization, in order to easily copy and paste useful links provided by IAM during Dynafed's account registration procedure.
After configuration, the Dynafed service can be deployed moving to `xdc_http_cache/dynafed` and executing the following commands:
```
docker-compose build # first time
docker-compose up -d
```
For any issues we invite to refer to the documentation:
[IAM documentation](https://indigo-iam.github.io/docs/v/current/)
[Dynafed documentation](http://lcgdm.web.cern.ch/dynafed-dynamic-federation-project)
