### Nginx
Nginx is the core component of xdc-http-cache. It consist of a customized build of the [OpenResty](https://openresty.org/en/) web platform, on top of which an additional module to enable inspection VOMS proxy x.509 certificates developed by INFN.
The code for the module can be found here:
[Nginx voms module](https://baltig.infn.it/storm2/ngx_http_voms_module/blob/master/src/ngx_http_voms_module.cpp).

It also includes an nginx patch to ignore a possible '0' character at the beginning of the HTTP request, to accept the so-called HTTPG requests not requiring delegation. The patch can found at [](https://baltig.infn.it/storm2/build/blob/master/docker/ngx-voms-build/assets/nginx-httpg_no_delegation.patch).

The OIDC support is enabled via the [zmartzone/lua-resty-openidc](https://github.com/zmartzone/lua-resty-openidc).

## Usage
This repository contains an example configuration for a single VO (`indigo-dc`).
In order to build the container, a valid x.509 certificate and key for the server hosting the caching service must be provided and placed under the `xdc_http_cache/certs` folder. 
The provided `nginx.conf` contains two environment variable needed for the `ngx_http_voms_module`:
```
env X509_VOMS_DIR=/vomsdir;
env X509_CERT_DIR=/etc/grid-security/certificates;
```
The `X509_VOMS_DIR` variable contains the path to the `vomsdir` folder containing the `lsc` files which contains the DN of the VOMS server and the DN of the CA.
The configuration options  for the `lua-resty-openidc` module should be modified with the parameters for the OIDC provider:
```
                  local opts = {
                    discovery = "https://iam.example/.well-known/openid-configuration",
                    token_signing_alg_values_expected = {"RS256"},
                    accept_none_alg = false,
                    accept_unsupported_alg = false,
                    jwk_expires_in = 24 * 60 * 60
                  }

```
Furthemore the storage endpoints for which the cache proxy the HTTP requests should be configured:
```
ngx.var.proxy = 'se.example:11443';
```
These parameters can be easily set moving to `xdc_http_cache/scripts`, running `configure_services.sh`, selecting cache service and following the instructions provided by the script.
### Cache configuration
The cache configuration can be done changing the following parameters:
```
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=local:10m max_size=10G use_temp_path=on inactive=30m;
```
For a complete reference of these parameters we refer to the official documentation for the  [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html).
### Cache performance tuning
Few more variable also affects the performance of the module:
```
              aio threads=default;
              directio 16M;
              output_buffers 2 1M;

              sendfile on;
              sendfile_max_chunk 4m;
              
              tcp_nodelay on;
              tcp_nopush on;

```
These settings has been tested and proved to be optimized for a mixed dataset of file sizes ranging for 5MB to 350MB. For smaller sizes of bigger sizes suitable parameters should be tested.






