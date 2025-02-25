#!/bin/bash

# fail on any error
set -eu 

# login to your docker hub account
docker login --username $DOCKER_HUB_USERNAME --password $DOCKER_HUB_PASSWORD

# build the docker image
docker build -f $IMAGE_TAG/Dockerfile -t $IMAGE_TAG .
