#!/usr/bin/env bash

dnf install -y gcc kernel-devel kernel-headers dkms make bzip2 perl

mkdir -p /tmp/virtualbox
mount -o loop /tmp/VBoxGuestAdditions.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rmdir /tmp/virtualbox
rm /tmp/*.iso
