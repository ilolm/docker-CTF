#!/bin/bash

set -e

# Starting docker daemon + starting ssh daemon
dockerd > /dev/null 2>&1 &
/usr/sbin/sshd -D > /dev/null 2>&1 &

# Adding images
docker image load -i /docker-images/nginx.tar
docker image load -i /docker-images/php-fpm.tar

# Cleaning images
rm -rf /docker-images
