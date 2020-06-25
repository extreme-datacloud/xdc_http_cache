#!/bin/bash 
set -ex

STORAGE_DIR=${STORAGE_DIR:-/storage}

for f in /etc/storm/webdav/sa.d/*.properties; do
  filename=$(basename -- $f)
  sa_name=${filename%.*}
  sudo mkdir -p ${STORAGE_DIR}/${sa_name}
  sudo chown -R storm:storm ${STORAGE_DIR}

  #------EDIT HERE TO CHANGE STORAGE AREA INITIAL CONTENT------#

  sudo printf 'test file 1 for %s group' "${sa_name}" > ${STORAGE_DIR}/${sa_name}/test_file_1.txt

  #----------------------STOP EDITING--------------------------#

done
