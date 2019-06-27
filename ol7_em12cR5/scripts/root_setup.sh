sh /vagrant/scripts/prepare_u01_disk.sh

sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set up environment for one-off actions." `date`
echo "******************************************************************************"
export ORACLE_HOSTNAME=ol7-emcc.localdomain
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.1.0.2/dbhome_1
export SOFTWARE_DIR=/u01/software
export ORA_INVENTORY=/u01/app/oraInventory
export SCRIPTS_DIR=/home/oracle/scripts
export DATA_DIR=/u01/oradata
export ORACLE_PASSWORD="oracle"
export MW_HOME=${ORACLE_BASE}/middleware
export PUBLIC_IP_ADDRESS=`ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
mkdir -p /u01/tmp
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01

echo "******************************************************************************"
echo "Set the hostname." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
${PUBLIC_IP_ADDRESS}  ${ORACLE_HOSTNAME}
EOF

cat > /etc/hostname <<EOF
${ORACLE_HOSTNAME}
EOF

hostname ${ORACLE_HOSTNAME}

echo "******************************************************************************"
echo "Set the oracle password." `date`
echo "******************************************************************************"
echo "oracle:${ORACLE_PASSWORD}"|chpasswd

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
echo "Create the database." `date`
echo "******************************************************************************"
su - oracle -c '/u01/software/oracle_create_database.sh'

su - oracle -c '/u01/software/em_install.sh'

echo "******************************************************************************"
echo "Run allroot.sh." `date`
echo "******************************************************************************"
sh ${MW_HOME}/oms/allroot.sh

su - oracle -c '/u01/software/em_config.sh'
echo "" > /etc/oragchomelist
