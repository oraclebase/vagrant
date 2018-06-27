# Prepare yum with the latest repos.
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum -y install yum-utils zip unzip
yum -y install oracle-database-server-12cR2-preinstall
#yum -y update

# Set up evironment for one-off actions.
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.2.0.1/db_1
export SOFTWARE_DIR=/u01/software
export ORA_INVENTORY=/u01/app/oraInventory
export SCRIPTS_DIR=/home/oracle/scripts

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p /u02/oradata
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01 /u02

# Copy the "oracle_setup.sh" config file from the vagrant directory and run it.
cp -f /vagrant/scripts/* ${SOFTWARE_DIR}
cp -f /vagrant/software/* ${SOFTWARE_DIR}
chown -R oracle.oinstall ${SOFTWARE_DIR}
chmod +x ${SOFTWARE_DIR}/*.sh

# Prepare environment and install the software.
su - oracle -c '/u01/software/oracle_user_environment_setup.sh'
su - oracle -c '/u01/software/oracle_software_installation.sh'

# Run root scripts.
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

# Create the database and install the ORDS software.
su - oracle -c '/u01/software/oracle_create_database.sh'
su - oracle -c '/u01/software/ords_software_installation.sh'
