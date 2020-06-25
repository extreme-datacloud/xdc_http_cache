# xdc_http_cache - Distributed system of HTTP-based storage

This project includes a playground for a demonstrator of a distributed system of storage, comprising storage elements, caches and redirectors, communicating via HTTPS.

# Getting started

The project consists of several docker-compose files with the purpose of either deploy the component that we are going to describe or testing them as whole local setup.
The service deployed consist of :
  - user interface
  - storage elements
  - cache (the caching server you actually contact)
  - federation server

Each service must be properly configured moving to `xdc_http_cache/scripts`, running `configure_services.sh`, selecting the desired service and following the instructions provided by the script.
Please notice that `configure_services.sh` is developed for CentOS7 and requires to be run by a user with `sudo` privileges. If your OS is not CentOS7, you can run the script `connect_configuration_container.sh`:  
this script will start a CentOS7 Docker container with this GitHub repository mounted in it; just move to `/xdc_http_cache/scripts` and run `configure_services.sh`, then exit when the configuration is completed.
## Repository structure
The repository is splitted in folders with at least one service setup docker-compose.yml file:

* ui (user interface service)
* iam (IAM OIDC  and voms-aa service)
* storage (Cache and Storm WebDAV service )
* dynafed (dynafed federator service)

Each service (apart from ui) can be started from the relevant folder with following commands:
```
docker-compose build
docker-compose up -d
```
Before doing this you have to follow the reference documentation in the Deployment and Administration section.
In order to work you don't need to instantiate all the services. Depending on the needs one or more services can deployed.
Recommended versions for Docker and docker-compose are (at least) the following:
  - `Docker version 19.03.5`
  - `docker-compose version 1.25.3`


# Deployment and Administration

* [ui](ui/README.md)
* [iam](iam/README.md)
* [Storm WebDAV](storage/storage-webdav/README.md)
* [nginx cache](storage/cache/README.md)
* [dynafed](dynafed/README.md)

