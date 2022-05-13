#!/usr/bin/env bash

# Remove DNF cache.
dnf clean all
rm -Rf /var/cache/dnf/*
rm -Rf /var/cache/yum/*

# Empty /tmp.
#rm -Rf /tmp/*

# Zero all empty space to aid compression.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Make sure Packer waits for operation to complete.
sync && sync
