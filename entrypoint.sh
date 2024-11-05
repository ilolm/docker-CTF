#!/bin/bash

set -e

# Starting docker daemon + starting ssh daemon
dockerd > /dev/null 2>&1 &
/usr/sbin/sshd -D > /dev/null 2>&1 &

# Waiting for docker engine to start (until 'docker info' returns non-zero exit-code sleep 1)
until docker info >/dev/null 2>&1; do sleep 1; done

# Adding php image
docker image load -i /docker-images/php-fpm.tar

# Cleaning images
rm -rf /docker-images

exec "$@"
