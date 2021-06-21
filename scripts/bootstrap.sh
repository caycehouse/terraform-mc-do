#!/bin/bash

# Run the minecraft docker instance
docker run -d \
    --name minecraft-server \
    --restart always \
    -p 25565:25565/tcp \
    -v /mnt/minecraft:/data \
    -e EULA="TRUE" \
    -e MEMORY="6144M" \
    -e TYPE="SPIGOT" \
    -e USE_AIKAR_FLAGS="TRUE" \
    itzg/minecraft-server