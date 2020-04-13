. /vagrant/scripts/config.sh

sh /vagrant/scripts/prepare_u01_disk.sh

sh /vagrant/scripts/install_os_packages.sh

sh /vagrant/scripts/configure_docker.sh

sh /vagrant/scripts/install_awx.sh

sh /vagrant/scripts/install_devops.sh

cp /vagrant/scripts/*yml  /root/.kcli
cp /vagrant/scripts/*tf  /root/projects/terraform
