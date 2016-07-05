#!/usr/bin/env bash

. ./docker_env.sh

docker attach $CONTAINER_NAME
# detach - Ctrl+p + Ctrl+q

exit 0
