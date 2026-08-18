. /vagrant/config/install.env

sh /vagrant/scripts/install_os_packages.sh

sh /vagrant/scripts/oracle_create_database.sh

mkdir -p ${SOFTWARE_DIR}
chown -R oracle:oinstall /u01

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
su - oracle -c 'sh /vagrant/scripts/apex_software_installation.sh'
su - oracle -c 'sh /vagrant/scripts/ords_software_installation.sh'

sh /vagrant/scripts/oracle_service_setup.sh
