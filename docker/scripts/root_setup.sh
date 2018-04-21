# Prepare yum with the latest repos.
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum install yum-utils -y
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_preview
yum-config-manager --enable ol7_developer

# Install docker and update everything.
yum install docker-engine btrfs-progs btrfs-progs-devel git -y
#yum update -y

# Prepare the drive for the docker images.
ls /dev/sd*
echo -e "n\np\n\n\n\nw" | fdisk /dev/sdb
ls /dev/sd*
docker-storage-config -s btrfs -d /dev/sdb1

# Enable experimental features.
sed -i -e "s|OPTIONS='--selinux-enabled'|OPTIONS='--selinux-enabled --experimental=true'|g" /etc/sysconfig/docker

# Enable Docker
systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service

# Create non-root docker user.
useradd docker_user
echo "docker_user  ALL=(ALL)  NOPASSWD: /usr/bin/docker" >> /etc/sudoers
echo "alias docker=\"sudo /usr/bin/docker\"" >> /home/docker_user/.bash_profile

# Configure docker-compose.
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "docker_user  ALL=(ALL)  NOPASSWD: /usr/local/bin/docker-compose" >> /etc/sudoers
echo "alias docker-compose=\"sudo /usr/local/bin/docker-compose\"" >> /home/docker_user/.bash_profile

# Copy the "curricula_setup.sh" config file from the vagrant directory and run it.
cp /vagrant/scripts/docker_user_setup.sh /home/docker_user/
chown docker_user:docker_user /home/docker_user/docker_user_setup.sh
chmod +x /home/docker_user/docker_user_setup.sh
sudo su - docker_user -c '/home/docker_user/docker_user_setup.sh'
