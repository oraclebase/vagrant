# Create a listener.ora file if it doesn't already exist.
if [ ! -f ${ORACLE_HOME}/network/admin/listener.ora ]; then
echo "LISTENER =
(DESCRIPTION_LIST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1))
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  )
)
USE_SID_AS_SERVICE_listener=on
" > ${ORACLE_HOME}/network/admin/listener.ora
fi


# Check if database already exists.
if [ ! -d ${DATA_DIR}/${ORACLE_SID} ]; then

  # The database files don't exist, so create a new database.
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
    -memoryMgmtType auto_sga                                                   \
    -totalMemory 1536                                                          \
    -storageType FS                                                            \
    -datafileDestination "${DATA_DIR}"                                         \
    -redoLogFileSize 50                                                        \
    -emConfiguration NONE                                                      \
    -ignorePreReqs

  # Set the PDB to auto-start.
  sqlplus / as sysdba <<EOF
alter system set db_create_file_dest='${DATA_DIR}';
alter pluggable database ${PDB_NAME} save state;
alter system set local_listener='localhost';
exit;
EOF


  # Flip the auto-start flag.
  cp /etc/oratab /tmp
  sed -i -e "s|${ORACLE_SID}:${ORACLE_HOME}:N|${ORACLE_SID}:${ORACLE_HOME}:Y|g" /tmp/oratab
  cp -f /tmp/oratab /etc/oratab

fi
