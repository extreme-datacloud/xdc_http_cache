#!/bin/bash
for i in `seq -w 1 10`;do dd if=/dev/urandom of=/storage/indigo-dc/$i-file.data bs=5MB count=1;done
