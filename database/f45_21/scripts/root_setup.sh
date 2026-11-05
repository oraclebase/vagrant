. /vagrant/config/install.env

sh /vagrant/scripts/prepare_disks.sh

sh /vagrant/scripts/install_os_packages.sh

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
chown -R oracle:oinstall ${SCRIPTS_DIR} /u01 /u02

echo "******************************************************************************"
echo "Prepare environment and install the software." `date`
echo "******************************************************************************" 
su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
su - oracle -c 'sh /vagrant/scripts/oracle_software_installation.sh'

echo "******************************************************************************"
echo "Run root scripts." `date`
echo "******************************************************************************" 
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

echo "******************************************************************************"
echo "Create the database." `date`
echo "******************************************************************************"
# Prevent egrep warning message which kills DBCA
sed -i -e "s|echo|#echo|g" /usr/bin/egrep
su - oracle -c 'sh /vagrant/scripts/oracle_create_database.sh'
