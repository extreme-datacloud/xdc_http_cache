# xdc_http_cache - Distributed system of HTTP-based storage

This project includes a playground for a demonstrator of a distributed system of storage, comprising storage elements, caches and redirectors, communicating via HTTPS.



# Description

The project consists of several docker-compose files with purpose of either deploy the component that we are going to describe of testing them as whole local setup.
The service deployed consist of :
  - storage elements
  - cache (the caching server you actually contact)
  - federation server

In this repository you will not find a client container which is supposed to be external to the system.

![Simple Cache](/images/Simple_Cache)
Format: ![Alt Text](url)


# Usage

To start the containers just run:
```
docker-compose -f docker-compose.yml up
```
Examples of curl
```
curl -v https://cache.example --cert /certs/3.cert.pem  --key /certs/3.key.pem --capath /etc/pki/ --cacert /certs/3.cert.pem
curl -v https://cache.example/test.txt --cert /certs/3.cert.pem  --key /certs/3.key.pem --capath /etc/pki/ --cacert /certs/3.cert.pem
curl -O  https://nginx-voms.example/test.txt --cert /certs/cache_example.cert.pem  --key /certs/cache_example.key.pem --capath /etc/pki/ --cacert /etc/pki/igi-test-ca.pem
```
Contacting directly the cache example. After split the proxy
```
curl -v https://vm-131-154-97-26.cloud.cnaf.infn.it:9443/test.txt --cert ./usercert.pem  --key ./userkey.pem --capath ../TerenaCA/ --cacert 1.pem
```
or
```
davix-get -P grid https://vm-131-154-97-26.cloud.cnaf.infn.it:9443/dteam/test.txt
davix-ls -P grid https://vm-131-154-97-26.cloud.cnaf.infn.it:9443/dteam/
```

### Certificate chain details
## Client
```
openssl x509 -in 3.cert.pem -issuer -noout
issuer=C = IT, O = IGI, CN = test0
openssl x509 -in 3.cert.pem -subject -noout
subject=C = IT, O = IGI, CN = test0, CN = 1744748182
```
## Cache
```
openssl x509 -in cache_example.cert.pem -issuer -noout
issuer=C = IT, O = IGI, CN = Test CA
openssl x509 -in cache_example.cert.pem -subject -noout
subject=C = IT, O = IGI, CN = cache.example
```
## proxy
```
#proxy_ssl_trusted_certificate
openssl x509 -in  igi-test-ca.pem -issuer -noout
issuer=C = IT, O = IGI, CN = Test CA
openssl x509 -in  ../trust-anchors/igi-test-ca.pem -subject -noout
subject=C = IT, O = IGI, CN = Test CA
#
```
##Storage element
```

```
### Davix
Working Example
```
davix-get -P grid https://xfer-1.cr.cnaf.infn.it:8443/dteam/smoke-test-ui01-virgo.cr.cnaf.infn.it-9284

```

### Dealing with Terena Certificates
```
openssl x509 -in vm-131-154-97-26_cloud_cnaf_infn_it.crt -noout -subject
subject= /DC=org/DC=terena/DC=tcs/C=IT/L=Frascati/O=Istituto Nazionale di Fisica Nucleare/CN=vm-131-154-97-26.cloud.cnaf.infn.it
openssl x509 -in vm-131-154-97-26_cloud_cnaf_infn_it.crt -noout -issuer
issuer= /C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3
```
The issuer is an intermediate CA
```
openssl x509 -in DigiCertCA.crt -noout -subject
subject= /C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3
openssl x509 -in DigiCertCA.crt -noout -issuer
issuer= /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Assured ID Root CA
```
So you have to download the `DigiCert Assured ID Root CA` CA cert. From the link [RootCA][https://dl.cacerts.digicert.com/DigiCertAssuredIDRootCA.crt]
and convert it from DER format to PEM
```
openssl x509 -inform DER -in DigiCertAssuredIDRootCA.crt -out DigiCertAssuredIDRootCA.pem -outform PEM
```
and verify the host cert with this command
```
openssl   verify -verbose  -CAfile DigiCertAssuredIDRootCA.pem -untrusted DigiCertCA.crt vm-131-154-97-26_cloud_cnaf_infn_it.crt
```
or you can manuallly chain the Root and intermediate CA certs
```
cat DigiCertAssuredIDRootCA.pem DigiCertCA.crt > Fullchain.pem
```
and verify
```
openssl   verify   -CAfile Fullchain.pem  vm-131-154-97-26_cloud_cnaf_infn_it.crt
```
For proxies
```
openssl verify -allow_proxy_certs -CAfile /etc/grid-security/certificates/INFN-CA-2015.pem -untrusted  1.pem usercert.pem
```


### dynafed
```
curl -v --cacert /digicert/Fullchain.pem --capath /etc/grid-security/certificates/ --cert /digicert/vm-131-154-97-26_cloud_cnaf_infn_it.crt --key /digicert/vm-131-154-97-26.cloud.cnaf.infn.it.key -L https://vm-131-154-97-26.cloud.cnaf.infn.it:11443/dteam/storm1_test.txt  -o /tmp/testfile.txt
curl -v --cacert /tmp/proxy --capath /etc/grid-security/certificates/ --cert /tmp/proxy --key /tmp/proxy -L https://vm-131-154-97-26.cloud.cnaf.infn.it:11443/dteam/storm1_test.txt  -o /tmp/testfile.txt
curl -v --cacert /digicert/proxy --capath /etc/grid-security/certificates/ --cert /digicert/proxy --key /digicert/proxy -L https://vm-131-154-97-26.cloud.cnaf.infn.it:11443/dteam/storm1_test.txt  -o /tmp/testfile.txt
```
