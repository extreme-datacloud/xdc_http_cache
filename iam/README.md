# IAM service
This  repository  contains also a recipe to instantiate a IAM  provider OIDC provider service. The `docker-compose.yml` deploys the following services:
* iam 
* vomsng

IAM is an Identity and Access Management service for which the documentation can be found at [IAM documentation](https://indigo-iam.github.io/docs/v/current/). In xdc-http-cache IAM is the OpenID connect provider. xdc-http-cache can use an external provider but in this deployment a specific configuration for IAM is configured.
The other service is `vomsng` which is part of the [VOMS Admin server](https://github.com/italiangrid/voms-admin-server) application. It allows to obtain a VOMS proxy from an instance.

## IAM deployment prerequisites
The IAM service deployment consist of four container: two for the mariadb and its data, one for iam service and an ssl terminator.
So in order for the service to work you must obtain a valid x509 certificate and put it in `xdc_http_cache/certs`. Then you must move to `xdc_http_cache/scripts`, run `configure_services.sh` selecting iam service and follow the instructions provided by the script.

## vomsng deployment prerequisites
Also the `vomsng` service needs a valid x509 certificate to work, this certificate being the same already put in `xdc_http_cache/certs`. 
The `nginx-voms` service is just the ssl terminator.

## Final setup
Please, be careful about timings the first time you start the services. The recommendation is to start db service in a separate `screen` session without daemonizing, i.e.:
```
screen
docker-compose up db # first time
```
Then, when the db service has completed its setup, start iam-be service in a separate `screen` session without daemonizing, i.e.:
```
screen
docker-compose up iam-be # first time
```
If iam-be service is able to setup and run, it means that the iam-be host registration on the db has been successful. At this point you can shutdown the services in the `screen` sessions with `CTRL+C` and start IAM with the following command:
```
docker-compose up
```
After building the container and running the services, in order to complete the setup, the user certificates must be added to the corresponding IAM account, so that IAM in turn will be able to generate the VOMS proxy when contacted. This can be be done on a per-user basis and adding the user to a group whose name matches the name of the VO.



