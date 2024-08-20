#!/bin/bash

set -e

dockerd &
/usr/sbin/sshd -D
