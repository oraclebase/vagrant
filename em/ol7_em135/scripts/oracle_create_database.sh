. /vagrant/config/install.env

# Create a listener.ora file if it doesn't already exist.
if [ ! -f ${ORACLE_HOME}/network/admin/listener.ora ]; then

  cat > ${ORACLE_HOME}/network/admin/listener.ora <<EOF
LISTENER = 
(DESCRIPTION_LIST = 
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) 
  ) 
) 
USE_SID_AS_SERVICE_listener=on
INBOUND_CONNECT_TIMEOUT_LISTENER=400
EOF

  cat > ${ORACLE_HOME}/network/admin/tnsnames.ora <<EOF
LISTENER = (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
${ORACLE_SID}= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ${ORACLE_SID})
  )
)
${PDB_NAME}= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ${PDB_NAME})
  )
)
EOF

  cat > ${ORACLE_HOME}/network/admin/sqlnet.ora <<EOF
SQLNET.INBOUND_CONNECT_TIMEOUT=400
EOF

fi


echo "******************************************************************************"
echo "Check if database already exists." `date`
echo "******************************************************************************"
if [ ! -d ${DATA_DIR}/${ORACLE_SID} ]; then

  echo "******************************************************************************"
  echo "The database files don't exist, so create a new database." `date`
  echo "******************************************************************************"
  lsnrctl start

  dbca -silent -createDatabase                                                 \
    -templateName General_Purpose.dbc                                          \
    -gdbname ${ORACLE_SID} -sid ${ORACLE_SID} -responseFile NO_VALUE           \
    -characterSet AL32UTF8                                                     \
    -sysPassword ${SYS_PASSWORD}                                               \
    -systemPassword ${SYS_PASSWORD}                                            \
    -createAsContainerDatabase true                                            \
    -numberOfPDBs 1                                                            \
    -pdbName ${PDB_NAME}                                                       \
    -pdbAdminPassword ${PDB_PASSWORD}                                          \
    -databaseType MULTIPURPOSE                                                 \
    -automaticMemoryManagement false                                           \
    -totalMemory 2048                                                          \
    -storageType FS                                                            \
    -datafileDestination "${DATA_DIR}"                                         \
    -redoLogFileSize 600                                                       \
    -emConfiguration NONE                                                      \
    -ignorePreReqs

  echo "******************************************************************************"
  echo "Set the PDB to auto-start and fix parameters." `date`
  echo "******************************************************************************"
  sqlplus / as sysdba <<EOF
alter system set db_create_file_dest='${DATA_DIR}';
alter pluggable database ${PDB_NAME} save state;
alter system set local_listener='LISTENER';

-- Recommended settings.
alter system set "_allow_insert_with_update_check"=true scope=both;

alter system set session_cached_cursors=200 scope=spfile;

-- Recommended: processes=600
alter system set processes=600 scope=spfile;

-- Recommended: pga_aggregate_target=1G
alter system set pga_aggregate_target=450M scope=spfile;

-- Recommended: sga_target=3G
alter system set sga_target=800M scope=spfile;

-- Recommended: shared_pool_size=600M
--alter system set shared_pool_size=600M scope=spfile;

SHUTDOWN IMMEDIATE;
STARTUP;

exit;
EOF


  echo "******************************************************************************"
  echo "Flip the auto-start flag." `date`
  echo "******************************************************************************"
  cp /etc/oratab /tmp
  sed -i -e "s|${ORACLE_SID}:${ORACLE_HOME}:N|${ORACLE_SID}:${ORACLE_HOME}:Y|g" /tmp/oratab
  cp -f /tmp/oratab /etc/oratab

fi
