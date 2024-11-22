. /vagrant/config/install.env

echo "******************************************************************************"
echo "Add stubs for midleware 12.2.1.4 on OL9. (Patch 35775632)" `date`
echo "*****************************************************************************"
#cd ${SCRIPTS_DIR}
#unzip -oq /vagrant/software/p35775632_190000_Linux-x86-64.zip
#cp stubs.tar ${MW_HOME}/lib/stubs
#cd ${MW_HOME}/lib/stubs
#tar -xf stubs.tar
#export ORACLE_HOME=${MW_HOME}
#${ORACLE_HOME}/bin/genclntsh

echo "******************************************************************************"
echo "Configure Cloud Control." `date`
echo "******************************************************************************"

echo "******************************************************************************"
echo "Build response file." `date`
echo "******************************************************************************"
#unset ORACLE_HOME

cat > /tmp/config.rsp <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${UNIX_GROUP_NAME}
INVENTORY_LOCATION=${ORA_INVENTORY}
STAGE_LOCATION=${SOFTWARE_DIR}
INSTALL_UPDATES_SELECTION=skip
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
ORACLE_MIDDLEWARE_HOME_LOCATION=${MW_HOME}
ORACLE_HOSTNAME=${ORACLE_HOSTNAME}
AGENT_BASE_DIR=${AGENT_BASE}
WLS_ADMIN_SERVER_USERNAME=${WLS_USERNAME}
WLS_ADMIN_SERVER_PASSWORD=${WLS_PASSWORD}
WLS_ADMIN_SERVER_CONFIRM_PASSWORD=${WLS_PASSWORD}
NODE_MANAGER_PASSWORD=${WLS_PASSWORD}
NODE_MANAGER_CONFIRM_PASSWORD=${WLS_PASSWORD}
ORACLE_INSTANCE_HOME_LOCATION=${GC_INST}
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=true
SOFTWARE_LIBRARY_LOCATION=${SOFTWARE_LIBRARY}
DATABASE_HOSTNAME=${DATABASE_HOSTNAME}
LISTENER_PORT=${LISTENER_PORT}
SERVICENAME_OR_SID=${PDB_NAME}
SYS_PASSWORD=${SYS_PASSWORD}
SYSMAN_PASSWORD=${SYSMAN_PASSWORD}
SYSMAN_CONFIRM_PASSWORD=${SYSMAN_PASSWORD}
DEPLOYMENT_SIZE=SMALL
AGENT_REGISTRATION_PASSWORD=${AGENT_PASSWORD}
AGENT_REGISTRATION_CONFIRM_PASSWORD=${AGENT_PASSWORD}
PLUGIN_SELECTION={}
b_upgrade=false
EM_INSTALL_TYPE=NOSEED
CONFIGURATION_TYPE=ADVANCED
CONFIGURE_SHARED_LOCATION_BIP=false
MANAGEMENT_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt.dbf
CONFIGURATION_DATA_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt_ecm_depot1.dbf
JVM_DIAGNOSTICS_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt_deepdive.dbf
EOF

echo "******************************************************************************"
echo "Perform silent installation." `date`
echo "******************************************************************************"
#unset CLASSPATH

# Fake Oracle Linux 8.
#export CV_ASSUME_DISTID=OL8

${MW_HOME}/sysman/install/ConfigureGC.sh -silent -responseFile /tmp/config.rsp

# Fix broken web tier by copying libclntshcore.so.12.1 file.
#cp /u01/app/oracle/agent/agent_13.5.0.0.0/instantclient/libclntshcore.so.12.1 /u01/app/oracle/middleware/ohs/lib/
#${MW_HOME}/bin/emctl start oms
