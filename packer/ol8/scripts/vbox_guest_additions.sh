#!/usr/bin/env bash

dnf update -y

mkdir -p /tmp/virtualbox
VERSION=$(cat /tmp/.vbox_version)
mount -o loop /tmp/VBoxGuestAdditions_$VERSION.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rmdir /tmp/virtualbox
rm /tmp/*.iso
