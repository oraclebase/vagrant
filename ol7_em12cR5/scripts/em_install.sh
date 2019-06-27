echo "******************************************************************************"
echo "Install Cloud Control." `date`
echo "******************************************************************************"
# To generate new response files.
#cd /vagrant/software/
#./em13300_linux64.bin -getResponseFileTemplates -outputLoc /tmp/

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

cd ${SOFTWARE_DIR}
mkdir -p em12cr5
unzip -oqd em12cr5 em12105_linux64_disk1.zip
unzip -oqd em12cr5 em12105_linux64_disk2.zip
unzip -oqd em12cr5 em12105_linux64_disk3.zip
cd em12cr5

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
FROM_LOCATION="${SOFTWARE_DIR}/em12cr5/oms/Disk1/stage/products.xml"
EOF

echo "******************************************************************************"
echo "Perform silent installation." `date`
echo "******************************************************************************"
./runInstaller -silent -responseFile /tmp/install.rsp -waitforcompletion


echo "******************************************************************************"
echo "Fix link error because we are using OL7." `date`
echo "******************************************************************************"
sed -i -e "s|-lipgo|-lipgo -ldms2|g" ${MW_HOME}/Oracle_WT/lib/sysliblist

cd ${MW_HOME}/Oracle_WT/webcache/lib

gcc -o webcached \
  -L$MW_HOME/Oracle_WT/webcache/lib/ -L$MW_HOME/Oracle_WT/lib/ -L$MW_HOME/Oracle_WT/lib/stubs/ \
  main.o libwebcache.a -Wl,-rpath,$MW_HOME/Oracle_WT/lib -liau -lnnz11 -lxml11 -lclntsh \
  -lcore11 -lunls11 -lnls11  $MW_HOME/Oracle_WT/lib/liboraz.a -ldmsapp -lons \
  `cat $MW_HOME/Oracle_WT/lib/sysliblist` -lrt -Wl,-rpath,$MW_HOME/Oracle_WT/lib -lm \
  `cat $MW_HOME/Oracle_WT/lib/sysliblist` -lrt -ldl -lm -L$MW_HOME/Oracle_WT/lib
 
mv ./webcached ../bin/.
chmod 750 ${MW_HOME}/Oracle_WT/webcache/bin/webcached
