# xdc_http_cache - Distributed system of HTTP-based storage

This project includes a playground for a demonstrator of a distributed system of storage, comprising storage elements, caches and redirectors, communicating via HTTPS.



# Description

The project consists of several docker-compose files with purpose of either deploy the component that we are going to describe of testing them as whole local setup.
The service deployed consist of :
  - user interface
  - storage elements
  - cache (the caching server you actually contact)
  - federation server

![Simple Cache](/images/Simple_Cache.png)

In the context of this work the client will authenticate to the storage element using proxy certificate augmented with VOMS Attribute Certificates or using an OIDC token. The role of the cache will be played by an nginx instance with an additional module for VOMS attribute support developed on purpose.

![Simple Cache](/images/Simple_Cache_VOMS_Enabled.png )

# Repository content
The repository contains deployment recipes for the following services:

* [ui](ui/README.md)
* [iam](iam/README.md)
* [Storm WebDav](storage/storage-webdav/README.md)
* [nginx cache](storage/cache/README.md)
* [dynafed](dynafed/README.md)



