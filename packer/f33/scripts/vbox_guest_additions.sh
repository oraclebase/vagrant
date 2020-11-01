#!/usr/bin/env bash

mkdir -p /tmp/virtualbox
mount -o loop /tmp/VBoxGuestAdditions.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rmdir /tmp/virtualbox
rm /tmp/*.iso
