sh /vagrant/scripts/prepare_u01_u02_disks.sh

sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set up environment for one-off actions." `date`
echo "******************************************************************************"
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.1.0.2/db_1
export SOFTWARE_DIR=/u01/software
export ORA_INVENTORY=/u01/app/oraInventory
export SCRIPTS_DIR=/home/oracle/scripts
export DATA_DIR=/u02/oradata

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01 /u02

echo "******************************************************************************"
echo "Copy the scripts and software." `date`
echo "******************************************************************************"
cp -f /vagrant/scripts/* ${SOFTWARE_DIR}
cp -f /vagrant/software/* ${SOFTWARE_DIR}
chown -R oracle.oinstall ${SOFTWARE_DIR}
chmod +x ${SOFTWARE_DIR}/*.sh

echo "******************************************************************************"
echo "Prepare environment and install the software." `date`
echo "******************************************************************************"
su - oracle -c '/u01/software/oracle_user_environment_setup.sh'
su - oracle -c '/u01/software/oracle_software_installation.sh'

echo "******************************************************************************"
echo "Run root scripts." `date`
echo "******************************************************************************"
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

echo "******************************************************************************"
echo "Create the database and install the ORDS software." `date`
echo "******************************************************************************"
su - oracle -c '/u01/software/oracle_create_database.sh'
su - oracle -c '/u01/software/ords_software_installation.sh'

sh /vagrant/scripts/oracle_service_setup.sh
