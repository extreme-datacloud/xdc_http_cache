#!/bin/bash
mv /bin/voms-proxy-init /voms-proxy-init.orig
echo '#!/bin/bash
/voms-proxy-init.orig --dont_verify_ac $@' | tee /bin/voms-proxy-init
chmod +x /bin/voms-proxy-init
