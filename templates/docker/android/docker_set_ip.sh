#!/usr/bin/env bash

. ./docker_env.sh

# get container ip
new_ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' "$CONTAINER_NAME")

# add host/ip keypair to dnsmasq
echo "address=/$HOSTNAME/$new_ip" > "/etc/dnsmasq.d/0host_$HOSTNAME"

# restart dnsmasq service
(echo -n 'Dnsmasq service... ' && systemctl restart dnsmasq && echo " restarted with code $?")

## Don't forget add `nameserver 127.0.0.1` to /etc/resolvconf.conf.head

exit 0
