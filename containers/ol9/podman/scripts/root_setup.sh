sh /vagrant/scripts/prepare_disks.sh

echo "******************************************************************************"
echo "Install necessary packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
dnf install -y dnf-utils zip unzip git
dnf install -y podman buildah skopeo

echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld

echo "******************************************************************************"
echo "SELinux." `date`
echo "******************************************************************************"
sed -i -e "s|SELINUX=enforcing|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive

echo "******************************************************************************"
echo "Make the docker.io registry available." `date`
echo "******************************************************************************"
sed -i -e "s|'container-registry.oracle.com', 'docker.io'|'docker.io', 'container-registry.oracle.com'|g" /etc/containers/registries.conf

echo "******************************************************************************"
echo "Create non-root docker user." `date`
echo "******************************************************************************"
groupadd -g 1042 container_fg
useradd -G container_fg container_user
mkdir -p /u01/volumes/ol7_21_ords_tomcat
mkdir -p /u01/volumes/ol7_21_ords_db
mkdir -p /u01/volumes/ol7_19_ords_tomcat
mkdir -p /u01/volumes/ol7_19_ords_db
mkdir -p /u01/volumes/ol7_183_ords_tomcat
mkdir -p /u01/volumes/ol7_183_ords_db
mkdir -p /u01/volumes/ol8_21_ords_tomcat
mkdir -p /u01/volumes/ol8_21_ords_db
mkdir -p /u01/volumes/ol8_19_ords_tomcat
mkdir -p /u01/volumes/ol8_19_ords_db
mkdir -p /u01/volumes/ol8_183_ords_tomcat
mkdir -p /u01/volumes/ol8_183_ords_db
chown -R container_user:container_fg /u01
chmod -R 775 /u01/volumes
chmod -R g+s /u01/volumes

# Add users so host reports process ownership properly. Not required.
useradd -u 500 oracle
useradd -u 501 tomcat

echo "container_user  ALL=(ALL)  NOPASSWD: /usr/bin/podman" >> /etc/sudoers
echo "alias podman=\"sudo /usr/bin/podman\"" >> /home/container_user/.bash_profile
echo "alias docker=\"sudo /usr/bin/podman\"" >> /home/container_user/.bash_profile

echo "******************************************************************************"
echo "Copy setup files to the local disks." `date`
echo "******************************************************************************"
cp /vagrant/scripts/container_user_setup.sh /home/container_user/
chown container_user:container_user /home/container_user/container_user_setup.sh
chmod +x /home/container_user/container_user_setup.sh
sudo su - container_user -c '/home/container_user/container_user_setup.sh'
