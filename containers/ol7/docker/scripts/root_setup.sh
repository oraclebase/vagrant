sh /vagrant/scripts/prepare_u01_disk.sh

echo "******************************************************************************"
echo "Prepare Yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
yum install -y yum-utils zip unzip git
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_addons

yum install -y oraclelinux-developer-release-el7
yum-config-manager --enable ol7_developer

echo "******************************************************************************"
echo "Install Docker." `date`
echo "******************************************************************************"
yum install -y docker-engine btrfs-progs btrfs-progs-devel
#yum update -y

echo "******************************************************************************"
echo "Prepare the drive for the docker images." `date`
echo "******************************************************************************"
ls /dev/sd*
echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdc

ls /dev/sd*
docker-storage-config -s btrfs -d /dev/sdc1

#echo "******************************************************************************"
#echo "Enable experimental features." `date`
#echo "******************************************************************************"
#sed -i -e "s|OPTIONS='--selinux-enabled'|OPTIONS='--selinux-enabled --experimental=true'|g" /etc/sysconfig/docker

echo "******************************************************************************"
echo "Enable Docker." `date`
echo "******************************************************************************"
systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service

echo "******************************************************************************"
echo "Create non-root docker user." `date`
echo "******************************************************************************"
groupadd -g 1042 docker_fg
useradd -G docker_fg docker_user
mkdir -p /u01/volumes/ol7_19_ords_tomcat
mkdir -p /u01/volumes/ol7_19_ords_db
mkdir -p /u01/volumes/ol7_183_ords_tomcat
mkdir -p /u01/volumes/ol7_183_ords_db
mkdir -p /u01/volumes/ol8_19_ords_tomcat
mkdir -p /u01/volumes/ol8_19_ords_db
mkdir -p /u01/volumes/ol8_183_ords_tomcat
mkdir -p /u01/volumes/ol8_183_ords_db
chown -R docker_user:docker_fg /u01
chmod -R 775 /u01/volumes
chmod -R g+s /u01/volumes

# Add users so host reports process ownership properly. Not required.
useradd -u 500 oracle
useradd -u 501 tomcat

echo "docker_user  ALL=(ALL)  NOPASSWD: /usr/bin/docker" >> /etc/sudoers
echo "alias docker=\"sudo /usr/bin/docker\"" >> /home/docker_user/.bash_profile

echo "******************************************************************************"
echo "Configure docker-compose." `date`
echo "******************************************************************************"
curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "docker_user  ALL=(ALL)  NOPASSWD: /usr/local/bin/docker-compose" >> /etc/sudoers
echo "alias docker-compose=\"sudo /usr/local/bin/docker-compose\"" >> /home/docker_user/.bash_profile

echo "******************************************************************************"
echo "Copy setup files to the local disks." `date`
echo "******************************************************************************"
cp /vagrant/scripts/docker_user_setup.sh /home/docker_user/
chown docker_user:docker_user /home/docker_user/docker_user_setup.sh
chmod +x /home/docker_user/docker_user_setup.sh
sudo su - docker_user -c '/home/docker_user/docker_user_setup.sh'
