#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SRC_DIR="$DIR/../src"
DOCKER_HOST_IP='172.17.42.1'
RUN_USER="$USER"
HOSTNAME='hybrid.dev'
CONTAINER_NAME='hybrid_main'
IMAGE_NAME='androidworkspace:0.0.1'
