. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create database." `date`
echo "******************************************************************************"
dbca -silent -createDatabase \
  -templateName General_Purpose.dbc \
  -gdbname ${ORACLE_UNQNAME} -responseFile NO_VALUE \
  -characterSet AL32UTF8 \
  -sysPassword ${SYS_PASSWORD} \
  -systemPassword ${SYS_PASSWORD} \
  -createAsContainerDatabase true \
  -numberOfPDBs 1 \
  -pdbName ${PDB_NAME} \
  -pdbAdminPassword ${PDB_PASSWORD} \
  -databaseType MULTIPURPOSE \
  -automaticMemoryManagement false \
  -totalMemory 1024 \
  -redoLogFileSize 50 \
  -emConfiguration NONE \
  -ignorePreReqs \
  -nodelist ${NODE1_HOSTNAME},${NODE2_HOSTNAME} \
  -storageType ASM \
  -diskGroupName +DATA \
  -recoveryGroupName +RECO \
  -useOMF true \
  -asmsnmpPassword ${SYS_PASSWORD}

echo "******************************************************************************"
echo "Save state of PDB to enable auto-start." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
ALTER PLUGGABLE DATABASE ${PDB_NAME} SAVE STATE;
EXIT;
EOF

echo "******************************************************************************"
echo "Check cluster configuration." `date`
echo "******************************************************************************"

echo "******************************************************************************"
echo "Output from crsctl stat res -t" `date`
echo "******************************************************************************"
${GRID_HOME}/bin/crsctl stat res -t

echo "******************************************************************************"
echo "Output from srvctl config database -d ${ORACLE_UNQNAME}" `date`
echo "******************************************************************************"
srvctl config database -d ${ORACLE_UNQNAME}

echo "******************************************************************************"
echo "Output from srvctl status database -d ${ORACLE_UNQNAME}" `date`
echo "******************************************************************************"
srvctl status database -d ${ORACLE_UNQNAME}

echo "******************************************************************************"
echo "Output from v\$active_instances" `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
SELECT inst_name FROM v\$active_instances;
EXIT;
EOF

