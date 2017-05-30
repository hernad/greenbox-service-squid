#!/bin/bash

docker rm -f squid
#docker run --name squid -d --restart=always \
#    --publish 3128:3128 \
#    --volume $(pwd)/squid.conf:/etc/squid.conf \
#    --volume $(pwd)/cache:/var/spool/squid3 \
#     sameersbn/squid:3.3.8-23

	

#--volume $(pwd)/squid.conf:/etc/squid.conf \
	

#-e UPDATE_BLACKLIST_URL=http://www.shallalist.de/Downloads/shallalist.tar.gz \

docker run --name squid \
        -d \
	--restart=always \
	-e WPAD_IP=192.168.168.101 \
	-e WPAD_NOPROXY_NET=192.168.168.0 \
        -e WPAD_NOPROXY_MASK=255.255.255.0 \
	-e SQUID_CONFIG_SOURCE=/custom-config \
        --volume $(pwd)/conf:/custom-config \
        --volume $(pwd)/cache:/var/spool/squid3 \
        --volume $(pwd)/BL:/var/lib/squidguard/db/BL \
	--publish 3128:3128 \
	--publish 80:80 \
       	muenchhausen/docker-squidguard:latest
