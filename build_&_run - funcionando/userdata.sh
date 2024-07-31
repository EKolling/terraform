#!/bin/bash

sudo su
apt-get update
apt-get install -y docker
service docker start
usermod -aG docker ubuntu

docker pull hello-world
docker run hello-word