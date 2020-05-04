#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys

class _Authlist(object):
    def __init__(self):
        print "I claim I am loading an authorization list from a file, maybe one day I will but ignored for now :-)"

myauthlist = _Authlist()

# The main function that has to be invoked from ugr to determine if a request
# has to be performed or not
def isallowed(clientname="unknown", remoteaddr="nowhere", resource="none", mode="0", fqans=None, keys=None):
    print "clientname", clientname
    print "remote address", remoteaddr
    print "fqans", fqans
    print "keys", keys
    print "mode", mode
    print "resource", resource

    path = resource.split('/')
    if(path[-1] == ''):
      del path[-1]
    if(path[0] == ''):
      del path[0]
    # Allow to read or list the top level directory
    if (len(path) <= 2):
      if (mode == 'r' or mode == 'l'):
        return 0
      else:
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
				for line in access:
					print "Resource:", resource
					print "Line: ", line
					print "Split: ", line.split()[0]
					if line.split()[0] in resource:
						accessFQAN = line.split()[1]
						accesskeys = line.split()[2]
						if (accessFQAN in fqans) and (mode in accesskeys):
							print "Name:", clientname
							print "FQAN:", fqans, "  ", accessFQAN
							print "Mode:", mode, "   ", accesskeys
							print "Resource ok:", resource
							return 0
			access.close()
    search.close()
    return 1


if __name__ == "__main__":
    r = isallowed(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5:])
    sys.exit(r)
