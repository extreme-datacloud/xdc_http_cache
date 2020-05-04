# IAM service
This  repository  contains also a recipe to instantiate a IAM  provider OIDC provider service. The `docker-compose.yml` deploys the following services:
* iam 
* voms-aa

IAM is an Identity and Access Management service for which the documentation can be found at [IAM documentation](https://indigo-iam.github.io/docs/v/current/). In xdc-http-cache IAM is the OpenID connect provider. xdc-http-cache can use an external provider but in this deployment a specific configuration for IAM is configured.
The other service is `voms-aa` which is part of the [VOMS Admin server](https://github.com/italiangrid/voms-admin-server) application. It allows to obtain a VOMS proxy from an instance.

## IAM deployment prerequisites
The IAM service deployment consist of four container: two for the mariadb and its data, one for iam service and an ssl terminator.
So in order for the service to work you must obtain a valid x509 certificate and the file [iam.conf](assets/iam-nginx/iam.conf) must be changed accordingly.

## voms-aa deployment prerequisites
Also the `voms-aa` service needs a valid x509 certificate to work. The the [Dockerfile](assets/voms-aa/docker/Dockerfile) must then be adapter before building the image changing the path of the certificates along with the name of VO configured.
The `voms-rdr` is just the ssl terminator which should be modified with the names and path of the server certificates [voms.conf](assets/voms-rdr/voms.conf).

## Final setup
After building the container and running the services in order to complete the setup the user certificates must be added to IAM, which in turn will be able to generate the VOMS proxy when contacted. This can be be done on a per-user basis and adding the user to a group which name matches the name of the VO.



