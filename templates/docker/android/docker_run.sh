#!/usr/bin/env bash

. ./docker_env.sh

LAST_ACTIVE=$(docker ps -q --no-trunc --filter="name=$CONTAINER_NAME" | head -n1)
LAST_CREATED=$(docker ps -aq --no-trunc --filter="name=$CONTAINER_NAME" | head -n1)

if [ ! -z "$LAST_ACTIVE" ]; then
    echo -e ">>> Container '$CONTAINER_NAME' already in use $LAST_ACTIVE\n"

elif [ ! -z "$LAST_CREATED" ]; then
    echo -e ">>> Run old container $LAST_CREATED\n"
    docker start "$CONTAINER_NAME"
    
else
    echo -e ">>> Create new container\n"
    docker run -i -t -d \
        --memory=1024MB \
        --cpuset-cpus=1 \
        --memory-swap=-1 \
        --hostname="$HOSTNAME" \
        --name="$CONTAINER_NAME" \
        -v "$SRC_DIR:/var/www" \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        -u "$RUN_USER" \
        "$IMAGE_NAME" /bin/bash /start.sh
        # --net="host"
fi

# docker inspect -f '{{ .NetworkSettings.IPAddress }}' "$CONTAINER_NAME"
docker inspect -f '{{ json .NetworkSettings }}' "$CONTAINER_NAME" | python -mjson.tool

echo "Hostname http://$HOSTNAME"
 
echo "Allow connect to X11 from user: $RUN_USER"
xhost +"local:$RUN_USER"

exit 0
