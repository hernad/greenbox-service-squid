#!/bin/bash

#docker run --name squid -d --restart=always \
#    --publish 3128:3128 \
#    --volume $(pwd)/squid.conf:/etc/squid.conf \
#    --volume $(pwd)/cache:/var/spool/squid3 \
#     sameersbn/squid:3.3.8-23

	
if [ ! -f shallalist.tar.gz ] ; then
   curl -LO http://www.shallalist.de/Downloads/shallalist.tar.gz
   tar xvf shallalist.tar.gz
fi
	

docker rm -f squid

#-e UPDATE_BLACKLIST_URL=http://www.shallalist.de/Downloads/shallalist.tar.gz \
#	-e WPAD_IP=192.168.168.101 \
#	-e WPAD_NOPROXY_NET=192.168.168.0 \
#        -e WPAD_NOPROXY_MASK=255.255.255.0 \
	
#--publish 80:80 \
docker run --name squid \
        -d \
	--restart=always \
        -e SQUID_CONFIG_SOURCE=/custom-config \
        --volume $(pwd)/conf:/custom-config \
        --volume $(pwd)/cache:/var/spool/squid3 \
        --volume $(pwd)/BL:/var/lib/squidguard/db/BL \
        --volume $(pwd)/squid.conf:/etc/squid3/squid.conf \
	--publish 3128:3128 \
       	muenchhausen/docker-squidguard:latest


echo setup transparent cache

INTERFACE=bond0

# http://www.tldp.org/HOWTO/TransparentProxy-6.html

#for port in 80 443 ; do
#   # mora -I da bi prije docker pravila bilo
#   sudo iptables -I PREROUTING -t nat -i $INTERFACE -p tcp --dport $port -j REDIRECT --to-port 3128
#done


# router side
# SQUID=192.168.168.101
# INTERFACE=br0
# iptables -t mangle -A PREROUTING -j ACCEPT -p tcp --dport 443 -s $SQUID
# iptables -t mangle -A PREROUTING -j ACCEPT -p tcp --dport 80 -s $SQUID
# iptables -t mangle -A PREROUTING -j MARK --set-mark 3 -p tcp --dport 443
# iptables -t mangle -A PREROUTING -j MARK --set-mark 3 -p tcp --dport 80
# ip rule add fwmark 3 table 2
# ip route add default via $SQUID dev $INTERFACE table 2



# https://coderwall.com/p/t_isaa/create-a-gateway-with-a-transparent-proxy-iptables-squid

# router
# WAN_INTERFACE=ppp0
# LAN_INTERFACE=br0
# LAN_NETWORK=192.168.168.0/24
# DIRECT_IP=192.168.168.125
# iptables -A FORWARD -o $WAN_INTERFACE -i $LAN_INTERFACE -s $LAN_NETWORK -m conntrack --ctstate NEW -j ACCEPT
# iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# iptables -A POSTROUTING -t nat -j MASQUERADE
# iptables -t nat -A PREROUTING -i $LAN_INTERFACE -s $LAN_NETWORK -p tcp --dport 80 -j REDIRECT --to-port 3128
# iptables -t nat -I PREROUTING 1 -i $LAN_INTERFACE -s $DIRECT_IP -p tcp -m tcp --dport 80 -j ACCEPT
