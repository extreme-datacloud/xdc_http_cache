# DynaFed
The DynaFed container provides a service capable of federating multiple remote storage areas.
DynaFed's authentication against the remote endpoints is managed via token exchange through IAM.
To register an account and a token exchange client for DynaFed on IAM, you must run the script `xdc_http_cache/scripts/configure_dynafed.sh` and follow the instructions. The IAM hostname must be provided as argument, i.e.:
```
cd scripts
./configure_dynafed.sh <IAM_hostname>
```
Please notice that `configure_dynafed.sh` is developed for CentOS7 and requires to be run by a user with `sudo` privileges. Before running `configure_dynafed.sh` it is recommended to start IAM service in a `screen` session with docker-compose without daemonization, in order to easily copy and paste useful links provided by IAM during Dynafed's account registration procedure.
After configuration, the DynaFed service can be deployed with the following commands:
```
docker-compose build # first time
docker-compose up -d
```
For any issues we invite to refer to the documentation:
[IAM documentation](https://indigo-iam.github.io/docs/v/current/)
[DynaFed documentation](http://lcgdm.web.cern.ch/dynafed-dynamic-federation-project)
