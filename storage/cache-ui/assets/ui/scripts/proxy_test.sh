#!/bin/bash
davix-put -P grid /home/storm/test_file_3.txt https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt
davix-ls -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt
davix-get -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt
davix-rm -P grid https://cloud-vm159.cloud.cnaf.infn.it:10443/myfed/indigo-dc/test_file_3.txt
