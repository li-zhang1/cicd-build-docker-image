#!/bin/bash

# fail on any error
set -eu

# use the docker tag command to give the image a new name
docker tag $IMAGE_TAG $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME

# push the image to your docker hub repository
docker push $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME