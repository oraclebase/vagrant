echo "******************************************************************************"
echo "Prepare the drive for the docker images." `date`
echo "******************************************************************************"
ls /dev/sd*
echo -e "n\np\n\n\n\nw" | fdisk /dev/sdc
ls /dev/sd*
docker-storage-config -s btrfs -d /dev/sdc1

echo "******************************************************************************"
echo "Enable experimental features." `date`
echo "******************************************************************************"
sed -i -e "s|OPTIONS='--selinux-enabled'|OPTIONS='--selinux-enabled --experimental=true'|g" /etc/sysconfig/docker

echo "******************************************************************************"
echo "Enable Docker." `date`
echo "******************************************************************************"
systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service
