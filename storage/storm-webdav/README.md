# The StoRM WebDAV service

The StoRM WebDAV service provides http/webdav access to resources shared on a filesystem.
If you want to modify the initial content of the StoRM WebDAV storage area, you can edit the script `xdc_http_cache/storage/storm-webdav/assets/scripts/init-storage.sh` in the section comprised between the lines `#------EDIT HERE TO CHANGE STORAGE AREA INITIAL CONTENT------#` and `#----------------------STOP EDITING--------------------------#`.
Fine tuning on the StoRM WebDAV service configuration can be done modifying the file `xdc_http_cache/storage/storm-webdav/assets/etc/sysconfig/storm-webdav`. See [StoRM WebDAV installation & operation guide](doc/storm-webdav-guide.md) for details.
To setup StoRM WebDAV, you must go to `xdc_http_cache/scripts`, run the script `configure_services.sh` selecting storm-webdav service, and follow the instructions provided by the script.
After configuration, the StoRM WebDAV service can be deployed moving to `xdc_http_cache/storage/storm_webdav` and executing the following commands:
```
docker-compose build # first time
docker-compose up -d
```
For any issues we invite to refer to the documentation:
[StoRM WebDAV documentation](https://italiangrid.github.io/storm/documentation/sysadmin-guide/1.11.9/storm-webdav-guide.html)

