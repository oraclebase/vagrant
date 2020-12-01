echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum install -y yum-utils zip unzip
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_preview
yum-config-manager --enable ol7_developer
yum install -y oracle-epel-release-el7
yum-config-manager --enable ol7_developer_EPEL

echo "******************************************************************************"
echo "Install Docker and Ansible." `date`
echo "******************************************************************************"
yum install -y docker-engine btrfs-progs btrfs-progs-devel
yum install -y ansible python3-pip python3-devel libselinux-python3

# AWX requirement.
yum install -y git gcc

#yum update -y
