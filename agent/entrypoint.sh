#!/bin/bash

# Try iptables firewall first (local Docker with --cap-add=NET_ADMIN)
if sudo /usr/local/bin/init-firewall.sh 2>/dev/null; then
    echo "Network restricted via iptables firewall"
else
    # Squid proxy mode (HPC/Perlmutter)
    if [ -n "$SQUID_PROXY" ]; then
        export http_proxy="http://$SQUID_PROXY"
        export https_proxy="http://$SQUID_PROXY"
        export HTTP_PROXY="http://$SQUID_PROXY"
        export HTTPS_PROXY="http://$SQUID_PROXY"
        readonly http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        echo "Network restricted via Squid proxy ($SQUID_PROXY)"
    else
        echo "WARNING: No network restriction active (no iptables, no SQUID_PROXY)"
    fi
fi

exec "$@"
