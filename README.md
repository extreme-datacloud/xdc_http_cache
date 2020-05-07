# xdc_http_cache - Distributed system of HTTP-based storage

This project includes a playground for a demonstrator of a distributed system of storage, comprising storage elements, caches and redirectors, communicating via HTTPS.

<p align="center">
  <img width="460" height="300" src="https://github.com/extreme-datacloud/xdc_http_cache/blob/master/images/Simple_Cache.png>
</p>

<p align="center">
  <img width="460" height="300" src="https://github.com/extreme-datacloud/xdc_http_cache/blob/master/images/Simple_Cache_VOMS_Enabled.png">
</p>

# Getting started

The project consists of several docker-compose files with purpose of either deploy the component that we are going to describe of testing them as whole local setup.
The service deployed consist of :
  - user interface
  - storage elements
  - cache (the caching server you actually contact)
  - federation server


# Developer
The repository contains deployment recipes for the following services:

* [ui](ui/README.md)
* [iam](iam/README.md)
* [Storm WebDav](storage/storage-webdav/README.md)
* [nginx cache](storage/cache/README.md)
* [dynafed](dynafed/README.md)

# Deployment and Administration


# User



