#!/usr/bin/env bash

. ./docker_env.sh

trap "tput cnorm -- normal" SIGHUP SIGINT SIGKILL SIGTERM SIGSTOP EXIT

tput civis -- invisible 
docker stats "$CONTAINER_NAME"

exit 0
