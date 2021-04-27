. /vagrant/config/install.env

sh /vagrant/scripts/prepare_u01_disk.sh

sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set up environment for one-off actions." `date`
echo "******************************************************************************"
export PUBLIC_IP_ADDRESS=`ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
mkdir -p /u01/tmp
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01

echo "******************************************************************************"
echo "Copy software." `date`
echo "******************************************************************************"
cp /vagrant/software/em13500_linux64* ${SOFTWARE_DIR}
chown -R oracle.oinstall ${SOFTWARE_DIR}

echo "******************************************************************************"
echo "Set the hostname." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
${PUBLIC_IP_ADDRESS}  ${ORACLE_HOSTNAME}  ${ORACLE_HOSTNAME_SHORT}
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
echo "Prepare environment and install the software." `date`
echo "******************************************************************************"
su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
su - oracle -c 'sh /vagrant/scripts/oracle_software_installation.sh'

echo "******************************************************************************"
echo "Run root scripts." `date`
echo "******************************************************************************"
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

if [ "${PATCH_DB}" = "true" ]; then
  su - oracle -c 'sh /vagrant/scripts/oracle_software_patch.sh'
fi

echo "******************************************************************************"
echo "Create the database." `date`
echo "******************************************************************************"
su - oracle -c 'sh /vagrant/scripts/oracle_create_database.sh'

su - oracle -c 'sh /vagrant/scripts/em_install.sh'

echo "******************************************************************************"
echo "Run allroot.sh." `date`
echo "******************************************************************************"
sh ${MW_HOME}/allroot.sh

su - oracle -c 'sh /vagrant/scripts/em_config.sh'
echo "" > /etc/oragchomelist
