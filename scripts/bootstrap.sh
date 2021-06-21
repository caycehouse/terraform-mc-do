#!/bin/bash

# Mount the data volume
mkdir -p /mnt/minecraft
echo '/dev/disk/by-id/scsi-0DO_Volume_minecraft /mnt/minecraft ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_minecraft /mnt/minecraft

# Run the minecraft docker instance
docker run -d \
    --name minecraft-server \
    --restart always \
    -p 25565:25565/tcp \
    -v /mnt/minecraft:/data \
    -e EULA=true \
    -e MEMORY=2500M \
    -e TYPE="SPIGOT" \
    -e USE_AIKAR_FLAGS=true \
    -e FORCE_REDOWNLOAD=true \
    itzg/minecraft-server