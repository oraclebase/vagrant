. /vagrant_config/install.env

echo "******************************************************************************"
echo "Do grid configuration." `date`
echo "******************************************************************************"
${GRID_HOME}/gridSetup.sh -silent -executeConfigTools \
        -responseFile ${GRID_HOME}/install/response/gridsetup.rsp \
        INVENTORY_LOCATION=${ORA_INVENTORY} \
        SELECTED_LANGUAGES=${ORA_LANGUAGES} \
        oracle.install.option=CRS_CONFIG \
        ORACLE_BASE=${ORACLE_BASE} \
        oracle.install.asm.OSDBA=dba \
        oracle.install.asm.OSASM=dba \
        oracle.install.crs.config.scanType=LOCAL_SCAN \
        oracle.install.crs.config.gpnp.scanName=${SCAN_NAME} \
        oracle.install.crs.config.gpnp.scanPort=${SCAN_PORT} \
        oracle.install.crs.config.ClusterConfiguration=STANDALONE \
        oracle.install.crs.config.configureAsExtendedCluster=false \
        oracle.install.crs.config.clusterName=${CLUSTER_NAME} \
        oracle.install.crs.config.gpnp.configureGNS=false \
        oracle.install.crs.config.autoConfigureClusterNodeVIP=false \
        oracle.install.crs.config.clusterNodes=${NODE1_FQ_HOSTNAME}:${NODE1_FQ_VIPNAME}:HUB,${NODE2_FQ_HOSTNAME}:${NODE2_FQ_VIPNAME}:HUB \
        oracle.install.crs.config.networkInterfaceList=${NET_DEVICE1}:${PUBLIC_SUBNET}:1,${NET_DEVICE2}:${PRIVATE_SUBNET}:5 \
        oracle.install.crs.configureGIMR=false \
        oracle.install.crs.config.storageOption=FLEX_ASM_STORAGE \
        oracle.install.crs.config.useIPMI=false \
        oracle.install.asm.storageOption=ASM \
        oracle.install.asm.diskGroup.name=CRS \
        oracle.install.asm.diskGroup.redundancy=NORMAL \
        oracle.install.asm.diskGroup.disksWithFailureGroupNames=/dev/oracleasm/asm-crs-disk1,CRSFG1,/dev/oracleasm/asm-crs-disk2,CRSFG2,/dev/oracleasm/asm-crs-disk3,CRSFG3 \
        oracle.install.asm.diskGroup.disks=/dev/oracleasm/asm-crs-disk1,/dev/oracleasm/asm-crs-disk2,/dev/oracleasm/asm-crs-disk3 \
        oracle.install.asm.diskGroup.diskDiscoveryString=/dev/oracleasm/* \
        oracle.install.asm.monitorPassword=${SYS_PASSWORD} \
        oracle.install.asm.SYSASMPassword=${SYS_PASSWORD} \
        oracle.install.asm.configureAFD=false \
        oracle.install.asm.monitorPassword=${SYS_PASSWORD} \
        oracle.install.crs.configureRHPS=false \
        oracle.install.crs.config.ignoreDownNodes=false \
        oracle.install.config.managementOption=NONE \
        oracle.install.config.omsPort=0 \
        oracle.install.crs.rootconfig.executeRootScript=false

echo "******************************************************************************"
echo "Create additional diskgroups." `date`
echo "******************************************************************************"
. /home/oracle/scripts/grid_env

sqlplus / as sysasm <<EOF
CREATE DISKGROUP data EXTERNAL REDUNDANCY DISK '/dev/oracleasm/asm-data-disk1'
       ATTRIBUTE 'compatible.asm'='19.0','compatible.rdbms'='19.0';
CREATE DISKGROUP reco EXTERNAL REDUNDANCY DISK '/dev/oracleasm/asm-reco-disk1'
       ATTRIBUTE 'compatible.asm'='19.0','compatible.rdbms'='19.0';

SET LINESIZE 100
COLUMN name FORMAT A30
SELECT name, compatibility FROM v\$asm_diskgroup ORDER BY name;
EXIT;
EOF

echo "******************************************************************************"
echo "Check cluster configuration." `date`
echo "******************************************************************************"
${GRID_HOME}/bin/crsctl stat res -t
