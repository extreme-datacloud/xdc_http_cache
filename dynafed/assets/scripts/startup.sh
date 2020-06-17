#!/bin/bash

# turn on bash's job control
set -m

APACHE_PID=`ps aux | grep httpd | grep -v grep | grep root | awk '{print $2}'`
PHP_PID=`ps aux | grep php | grep -v grep | grep root | awk '{print $2}'`
MEMCACHED_PID=`ps aux | grep memcach | grep -v grep | grep root | awk '{print $2}'`

if [ ! -z $APACHE_PID ]; then kill  $APACHE_PID; fi
if [ ! -z $PHP_PID ]; then kill  $PHP_PID; fi
if [ ! -z $MEMCACHED_PID ]; then kill  $MEMCACHED_PID; fi

source /etc/profile.d/oidc-agent.sh
/oidc_expect.sh
/oidc_get_token.sh

rm -rf /run/httpd/*

/usr/sbin/apachectl -k start &

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apache : $status"
  exit $status
fi

/usr/bin/memcached -m 64 -p 11211 -c 4096 -b 4096 -t 2 -R 200 -n 72 -f 1.25 -u memcached -o slab_reassign slab_automove &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start memcached: $status"
  exit $status
fi

/usr/sbin/php-fpm --daemonize &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi

#/usr/sbin/crond &
#status=$?
#if [ $status -ne 0 ]; then
#  echo "Failed to start crond: $status"
#  exit $status
#fi

APACHE_PID=`ps aux | grep httpd | grep -v grep | grep root | awk '{print $2}'`
PHP_PID=`ps aux | grep php | grep -v grep | grep root | awk '{print $2}'`
MEMCACHED_PID=`ps aux | grep memcach | grep -v grep | grep root | awk '{print $2}'`
#CRON_PID=`ps aux | grep cron | grep -v grep | grep root | awk '{print $2}'`

while sleep 10; do
  ps aux |grep apache |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep memcached |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep php |grep -q -v grep
  PROCESS_3_STATUS=$?
  #ps aux |grep cron |grep -q -v grep
  #PROCESS_4_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
  trap "kill  $APACHE_PID $PHP_PID $MEMCACHED_PID" SIGINT
done
