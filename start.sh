#!/bin/bash

docker rm -f squid
docker run --name squid -d --restart=always \
    --publish 3128:3128 \
    --volume $(pwd)/squid.conf:/etc/squid.conf \
    --volume $(pwd)/cache:/var/spool/squid3 \
     sameersbn/squid:3.3.8-23
