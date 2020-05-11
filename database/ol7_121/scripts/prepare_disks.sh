function prepare_disk {
  MOUNT_POINT=$1
  DISK_DEVICE=$2

  echo "******************************************************************************"
  echo "Prepare ${MOUNT_POINT} disk." `date`
  echo "******************************************************************************"
  # New partition for the whole disk.
  echo -e "n\np\n1\n\n\nw" | fdisk ${DISK_DEVICE}

  # Add file system.
  mkfs.xfs -f ${DISK_DEVICE}1

  # Mount it.
  UUID=`blkid -o value ${DISK_DEVICE}1 | grep -v xfs`
  mkdir ${MOUNT_POINT}
  echo "UUID=${UUID}  ${MOUNT_POINT}    xfs    defaults 1 2" >> /etc/fstab
  mount ${MOUNT_POINT}
}

prepare_disk /u01 /dev/sdb
prepare_disk /u02 /dev/sdc
