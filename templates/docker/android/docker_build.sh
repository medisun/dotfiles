#!/usr/bin/env bash

. ./docker_env.sh

# docker build --no-cache -t "$IMAGE_NAME" "$DIR"
docker build -t "$IMAGE_NAME" "$DIR" && \
notify-send "Container '$IMAGE_NAME' is built"

exit 0
