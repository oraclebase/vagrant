echo "******************************************************************************"
echo "Configure shared disks." `date`
echo "******************************************************************************"
echo "******************************************************************************"
echo "Partition disks." `date`
echo "******************************************************************************"
if [ ! -e /dev/sdc1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdc
fi
if [ ! -e /dev/sdd1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdd
fi
if [ ! -e /dev/sde1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sde
fi
if [ ! -e /dev/sdf1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdf
fi
ls /dev/sd*

echo "******************************************************************************"
echo "Configure udev." `date`
echo "******************************************************************************"
cat > /etc/scsi_id.config <<EOF
options=-g
EOF

ASM_DISK1=`/usr/lib/udev/scsi_id -g -u -d /dev/sdc`
ASM_DISK2=`/usr/lib/udev/scsi_id -g -u -d /dev/sdd`
ASM_DISK3=`/usr/lib/udev/scsi_id -g -u -d /dev/sde`
ASM_DISK4=`/usr/lib/udev/scsi_id -g -u -d /dev/sdf`

cat > /etc/udev/rules.d/99-oracle-asmdevices.rules <<EOF
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK1}", SYMLINK+="oracleasm/asm-disk1", OWNER="oracle", GROUP="dba", MODE="0660"
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK2}", SYMLINK+="oracleasm/asm-disk2", OWNER="oracle", GROUP="dba", MODE="0660"
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK3}", SYMLINK+="oracleasm/asm-disk3", OWNER="oracle", GROUP="dba", MODE="0660"
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK4}", SYMLINK+="oracleasm/asm-disk4", OWNER="oracle", GROUP="dba", MODE="0660"
EOF

# Do partprobe and reload twice.
# Sometimes links don't all appear on first run.
/sbin/partprobe /dev/sdc1
/sbin/partprobe /dev/sdd1
/sbin/partprobe /dev/sde1
/sbin/partprobe /dev/sdf1
sleep 10
/sbin/udevadm control --reload-rules
sleep 10
/sbin/partprobe /dev/sdc1
/sbin/partprobe /dev/sdd1
/sbin/partprobe /dev/sde1
/sbin/partprobe /dev/sdf1
sleep 10
/sbin/udevadm control --reload-rules
sleep 10
ls -al /dev/oracleasm/*
