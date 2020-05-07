# xdc_http_cache - Distributed system of HTTP-based storage

This project includes a playground for a demonstrator of a distributed system of storage, comprising storage elements, caches and redirectors, communicating via HTTPS.

# Getting started

The project consists of several docker-compose files with purpose of either deploy the component that we are going to describe of testing them as whole local setup.
The service deployed consist of :
  - user interface
  - storage elements
  - cache (the caching server you actually contact)
  - federation server

## Repository structure
The repository is splitted in folders with at least one service setup docker-compose.yml file:

* ui (user interface service)
* iam (IAM OIDC  and voms-aa service)
* storage (Cache and Storm WebDAV service )
* dynafed (dynafed federator service)

Each service can be started from the relevant folder with following commands:
```
docker-compose build
docker-compose up -d
```
Before doing this you have to follow the reference documentation in the Deployment and Administration section.
In order to work you don't need to instantiate all the services. Depending on the needs one or more services can deployed.

# Deployment and Administration

* [ui](ui/README.md)
* [iam](iam/README.md)
* [Storm WebDAV](storage/storage-webdav/README.md)
* [nginx cache](storage/cache/README.md)
* [dynafed](dynafed/README.md)

