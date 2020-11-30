. /vagrant/scripts/config.sh

sh /vagrant/scripts/prepare_u01_disk.sh

sh /vagrant/scripts/install_os_packages.sh

sh /vagrant/scripts/configure_docker.sh

chown -Rv vagrant:docker /u01 

usermod -a -G docker vagrant

sudo -u vagrant sh /vagrant/scripts/install_awx.sh
