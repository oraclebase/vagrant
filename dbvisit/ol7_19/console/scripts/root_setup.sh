. /vagrant_config/install.env

sh /vagrant_scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle

sh /vagrant_scripts/configure_hosts_base.sh

sh /vagrant_scripts/configure_chrony.sh

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

sh /vagrant_scripts/configure_hostname.sh

echo "******************************************************************************"
echo "Configure Dbvisit Base." `date`
echo "******************************************************************************"
mkdir /usr/dbvisit
chown -R oracle:oinstall /usr/dbvisit

su - oracle -c 'sh /vagrant/scripts/configure_dbvisit.sh'
