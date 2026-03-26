FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    squid \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Domain whitelist (single source of truth for iptables + Squid)
COPY shared/allowed-domains.conf /tmp/allowed-domains.conf
COPY proxy/squid.conf /etc/squid/squid.conf

# Generate domain ACLs from shared whitelist
RUN grep -v '^[[:space:]]*#' /tmp/allowed-domains.conf | \
    grep -v '^[[:space:]]*$' | \
    grep -v '^@' | \
    sed 's/.*/acl allowed_domains dstdomain &/' > /tmp/domain-acls && \
    sed -i '/# __DOMAIN_ACLS__/r /tmp/domain-acls' /etc/squid/squid.conf && \
    sed -i '/# __DOMAIN_ACLS__/d' /etc/squid/squid.conf && \
    rm -f /tmp/allowed-domains.conf /tmp/domain-acls

# Writable dirs for squid (podman-hpc remaps UIDs, so keep group-writable)
RUN mkdir -p /tmp/squid && chown proxy:proxy /tmp/squid && chmod 775 /tmp/squid

EXPOSE 3128

CMD ["squid", "-N", "-f", "/etc/squid/squid.conf"]
