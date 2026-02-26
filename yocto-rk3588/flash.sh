#!/bin/sh

loader_file=$YOCTO_DIR/build/tmp/deploy/images/$MACHINE/loader.bin
image_file=$YOCTO_DIR/build/tmp/deploy/images/$MACHINE/$IMAGE-$MACHINE.rootfs.wic

echo "Flash $image_file"

# Download loader.bin
sudo $YOCTO_DIR/tools/rkdeveloptool db $loader_file > /dev/null 2>&1

# Update Flash
sudo $YOCTO_DIR/tools/rkdeveloptool wl 0x0 $image_file

# Reboot device
sudo $YOCTO_DIR/tools/rkdeveloptool rd
