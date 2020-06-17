#!/usr/bin/python
# -*- coding: utf-8 -*-

##########################################################
#  adapted to implement gridmap based authentication
#  needs:
#        /etc/grid-security/grid-mapfile
#         (created by edg-mkgridmap)
#        /etc/grid-security/accessfile
#  access file contains lines like:
#     /myfed/S3-Atlas atlas rl
#  meaning:
#     authorization is for /myfed/S3-Atlas and below
#     authorization is for anyone in VO atlas
#     authorization is for read and list access
#
#     top level /myfed can be read/listed by anyone
#
#  multiple entries for the same certificate but for
#  different VOs in grid-mapfile are allowed
#
##########################################################
# version 1, May 2017, M.Ebert, mebert@uvic.ca
#
#
##########################################################

import sys

# A class that one day may implement an authorization list loaded
# from a file during the initialization of the module.
# If this list is written only during initialization, and used as a read-only thing
# no synchronization primitives (e.g. semaphores) are needed, and the performance will be maximized
class _Authlist(object):
  def __init__(self):
    print "I claim I am loading an authorization list from a file, maybe one day I will but ignored for now :-)"

# Initialize a global instance of the authlist class, to be used inside the isallowed() function
myauthlist = _Authlist()


# The main function that has to be invoked from ugr to determine if a request
# has to be performed or not
def isallowed(clientname="unknown", remoteaddr="nowhere", resource="none", mode="0", fqans=None, keys=None):
  with open('/tmp/auth.log','w') as log:
    path = resource.split('/')
    log.write("Calling script with clientname : %s remoteaddr : %s resource : %s mode : %s fqans : %s keys : %s"%(clientname,remoteaddr,resource,mode,fqans,keys))
    log.write("Path is %s"%path)
    if(path[-1] == ''):
      del path[-1]
    if(path[0] == ''):
      del path[0]
    # Allow to read or list the top level directory
    if (len(path) <= 2):
      if (mode == 'r' or mode == 'l'):
        log.write("Exiting: ACCESS GRANTED")
        return 0
      else:
        log.write("Exiting: ACCESS NOT GRANTED")
        return 1
    # deny to anonymous user for any write mode
    if (clientname == 'nobody'):
      return 1
    # allow writing to anyone else who is not nobody
    with open('/etc/grid-security/grid-mapfile') as search:
      for line in search:
        if clientname in line:
          fqans = line.split()[-1]
          with open('/etc/grid-security/accessfile') as access:
            #/dteam/* /myfed/dteam rl
            for line in access:
              if mode in line.split()[2]:
                log.write("Checking mode: %s is in accessfile %s"%(mode,line.split()[2]))
                #accessFQAN = line.split()[1]
                #accesskeys = line.split()[2]
                #log.write("accessFQAN: %s accesskeys %s"%(accessFQAN,accesskeys))
                #if (accessFQAN in fqans) and (mode in accesskeys):
                log.write("Exiting: ACCESS GRANTED")
                return 0
            access.close()
      search.close()
    log.write("Exiting: ACCESS NOT GRANTED")
    log.close()
    return 1

#------------------------------
if __name__ == "__main__":
  r = isallowed(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5:])
  sys.exit(r)
