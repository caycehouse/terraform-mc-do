#!/bin/bash

# Run the minecraft docker instance
docker run -d \
    --name minecraft-server \
    --restart always \
    -p 25565:25565/tcp \
    -v /mnt/minecraft:/data \
    -e EULA=true \
    -e MEMORY=3072M \
    -e TYPE="SPIGOT" \
    -e USE_AIKAR_FLAGS=true \
    -e FORCE_REDOWNLOAD=true \
    itzg/minecraft-server