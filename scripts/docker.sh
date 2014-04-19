#!/bin/bash

apt-get -y update
apt-get -y install docker.io

# Giving non-root access
gpasswd -a vagrant docker

