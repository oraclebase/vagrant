echo "******************************************************************************"
echo "Prepare /u01 disk." `date`
echo "******************************************************************************"
# New partition for the whole disk.
echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdb

# Add file system.
mkfs.ext4 /dev/sdb1

# Mount it.
UUID=`blkid -o value --match-tag UUID /dev/sdb1`
mkdir /u01
cat >> /etc/fstab <<EOF
UUID=${UUID}  /u01    ext4    defaults 1 2
EOF
mount /u01

df -h
