. /vagrant_config/install.env

echo "******************************************************************************"
echo "Enable read-only Oracle home." `date`
echo "******************************************************************************"
cd $ORACLE_HOME/bin
./roohctl -enable 


echo "******************************************************************************"
echo "Configure network scripts." `date`
echo "******************************************************************************"

cat > ${READONLY_HOME}/network/admin/tnsnames.ora <<EOF
LISTENER${DB_DOMAIN_STR} = (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_FQ_HOSTNAME})(PORT = 1521))

${NODE1_DB_UNIQUE_NAME}${DB_DOMAIN_STR} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE1_FQ_HOSTNAME})(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ${ORACLE_SID})
    )
  )

${NODE2_DB_UNIQUE_NAME}${DB_DOMAIN_STR} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_FQ_HOSTNAME})(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ${ORACLE_SID})
    )
  )
EOF


cat > ${READONLY_HOME}/network/admin/listener.ora <<EOF
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_FQ_HOSTNAME})(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = ${NODE2_DB_UNIQUE_NAME})
      (SID_NAME = ${ORACLE_SID})
      (ORACLE_HOME = ${ORACLE_HOME})
    )
    (SID_DESC =
      (GLOBAL_DBNAME = ${NODE2_DB_UNIQUE_NAME}${DB_DOMAIN_STR})
      (SID_NAME = ${ORACLE_SID})
      (ORACLE_HOME = ${ORACLE_HOME})
    )
    (SID_DESC =
      (SID_NAME = ${ORACLE_SID})
      (GLOBAL_DBNAME = ${NODE2_DB_UNIQUE_NAME}_DGMGRL${DB_DOMAIN_STR})
      (ORACLE_HOME = ${ORACLE_HOME})
      (ENVS="TNS_ADMIN=${ORACLE_HOME}/network/admin")
    )
  )

ADR_BASE_LISTENER = ${ORACLE_BASE}
INBOUND_CONNECT_TIMEOUT_LISTENER=400
EOF


cat > ${READONLY_HOME}/network/admin/sqlnet.ora <<EOF
SQLNET.INBOUND_CONNECT_TIMEOUT=400
EOF

# Adding the Native Network Encryption was suggested by Claudia Hüffer, Peter Wahl and Richard Evans.
# I've made it optional.
if [ "${NATIVE_NETWORK_ENCRYPTION}" = "true" ]; then
  cat >> ${READONLY_HOME}/network/admin/sqlnet.ora <<EOF
SQLNET.ENCRYPTION_SERVER=REQUIRED
SQLNET.ENCRYPTION_TYPES_SERVER=(AES256)

SQLNET.ENCRYPTION_CLIENT=REQUIRED
SQLNET.ENCRYPTION_TYPES_CLIENT=(AES256)

SQLNET.CRYPTO_CHECKSUM_SERVER=REQUIRED
SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA256)

SQLNET.CRYPTO_CHECKSUM_CLIENT=REQUIRED
SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT = (SHA256)
EOF
fi

if [ "${DB_DOMAIN}" != "" ]; then
  cat >> ${READONLY_HOME}/network/admin/sqlnet.ora <<EOF
NAMES.DEFAULT_DOMAIN=${DB_DOMAIN}
EOF
fi

echo "******************************************************************************"
echo "Restart listener." `date`
echo "******************************************************************************"

lsnrctl stop
lsnrctl start
lsnrctl status

echo "******************************************************************************"
echo "Create directories, passwordfile and temporary init.ora file." `date`
echo "******************************************************************************"

mkdir -p /u01/oradata/${ORACLE_SID^^}/pdbseed
mkdir -p /u01/oradata/${ORACLE_SID^^}/pdb1
mkdir -p ${ORACLE_BASE}/fast_recovery_area/${ORACLE_SID}
mkdir -p ${ORACLE_BASE}/admin/${ORACLE_SID}/adump

orapwd file=$ORACLE_HOME/dbs/orapw${ORACLE_SID} password=${SYS_PASSWORD} entries=10

cat > /tmp/init${ORACLE_SID}_stby.ora <<EOF
*.db_name='${ORACLE_SID}'
EOF

echo "******************************************************************************"
echo "Create auxillary instance." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
--shutdown immediate;
startup nomount pfile='/tmp/init${ORACLE_SID}_stby.ora';
exit;
EOF


echo "******************************************************************************"
echo "Create standby database using RMAN duplicate." `date`
echo "******************************************************************************"
rman target sys/${SYS_PASSWORD}@${NODE1_DB_UNIQUE_NAME} auxiliary sys/${SYS_PASSWORD}@${NODE2_DB_UNIQUE_NAME} <<EOF

duplicate target database
  for standby
  from active database
  dorecover
  spfile
    set db_unique_name='${NODE2_DB_UNIQUE_NAME}' comment 'Is standby'
  nofilenamecheck;
  
exit;
EOF

echo "******************************************************************************"
echo "Enable the broker." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF

alter system set dg_broker_start=true;

EXIT;
EOF


echo "******************************************************************************"
echo "Configure broker (on primary) and display configuration." `date`
echo "******************************************************************************"
dgmgrl sys/${SYS_PASSWORD}@${NODE1_DB_UNIQUE_NAME} <<EOF
remove configuration;
create configuration my_dg_config as primary database is ${NODE1_DB_UNIQUE_NAME} connect identifier is ${NODE1_DB_UNIQUE_NAME}${DB_DOMAIN_STR};
add database ${NODE2_DB_UNIQUE_NAME} as connect identifier is ${NODE2_DB_UNIQUE_NAME}${DB_DOMAIN_STR};
enable configuration;
show configuration;
show database ${NODE1_DB_UNIQUE_NAME};
show database ${NODE2_DB_UNIQUE_NAME};
exit;
EOF

echo "******************************************************************************"
echo "Validate configuration." `date`
echo "******************************************************************************"
# Adding the validation step was suggested by Claudia Hüffer, Peter Wahl and Richard Evans.
sleep 60
dgmgrl sys/${SYS_PASSWORD}@${NODE1_DB_UNIQUE_NAME} <<EOF
validate database ${NODE1_DB_UNIQUE_NAME};
validate database ${NODE2_DB_UNIQUE_NAME};
validate database ${NODE2_DB_UNIQUE_NAME} spfile;
validate static connect identifier for ${NODE1_DB_UNIQUE_NAME};
validate static connect identifier for ${NODE2_DB_UNIQUE_NAME};
exit;
EOF
