. /vagrant/config/install.env

echo "******************************************************************************"
echo "Install Cloud Control." `date`
echo "******************************************************************************"
# To generate new response files.
#cd /vagrant/software/
#./em13500_linux64.bin -getResponseFileTemplates -outputLoc /tmp/

echo "******************************************************************************"
echo "Create required directories." `date`
echo "******************************************************************************"
mkdir -p ${MW_HOME}
mkdir -p ${AGENT_BASE}
mkdir -p ${GC_INST}
# Make sure they are empty for a re-run.
rm -Rf ${MW_HOME}/*
rm -Rf ${AGENT_BASE}/*
rm -Rf ${GC_INST}/*

echo "******************************************************************************"
echo "Build response file." `date`
echo "******************************************************************************"
cat > /tmp/install.rsp <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${UNIX_GROUP_NAME}
INVENTORY_LOCATION=${ORA_INVENTORY}
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
INSTALL_UPDATES_SELECTION=skip
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
CONFIGURATION_TYPE=LATER
CONFIGURE_SHARED_LOCATION_BIP=false
MANAGEMENT_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt.dbf
CONFIGURATION_DATA_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt_ecm_depot1.dbf
JVM_DIAGNOSTICS_TABLESPACE_LOCATION=${DATA_DIR}/${ORACLE_SID^^}/${PDB_NAME}/mgmt_deepdive.dbf
EOF

echo "******************************************************************************"
echo "Perform silent installation." `date`
echo "******************************************************************************"
unset CLASSPATH

chmod u+x ${SOFTWARE_DIR}/em13500_linux64.bin
${SOFTWARE_DIR}/em13500_linux64.bin -silent -responseFile /tmp/install.rsp
