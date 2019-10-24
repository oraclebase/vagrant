. /vagrant_config/install.env

echo "******************************************************************************"
echo "Configure network scripts." `date`
echo "******************************************************************************"

cat > ${ORACLE_HOME}/network/admin/tnsnames.ora <<EOF
LISTENER = (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_HOSTNAME})(PORT = 1521))

${NODE1_DB_UNIQUE_NAME} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE1_HOSTNAME})(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ${ORACLE_SID})
    )
  )

${NODE2_DB_UNIQUE_NAME} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_HOSTNAME})(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ${ORACLE_SID})
    )
  )
EOF


cat > ${ORACLE_HOME}/network/admin/listener.ora <<EOF
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ${NODE2_HOSTNAME})(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = ${NODE2_DB_UNIQUE_NAME}_DGMGRL)
      (ORACLE_HOME = ${ORACLE_HOME})
      (SID_NAME = ${ORACLE_SID})
    )
  )

ADR_BASE_LISTENER = ${ORACLE_BASE}
INBOUND_CONNECT_TIMEOUT_LISTENER=400
EOF


cat > ${ORACLE_HOME}/network/admin/sqlnet.ora <<EOF
SQLNET.INBOUND_CONNECT_TIMEOUT=400
EOF

echo "******************************************************************************"
echo "Restart listener." `date`
echo "******************************************************************************"

lsnrctl stop
lsnrctl start

echo "******************************************************************************"
echo "Create directories, passwordfile and temporary init.ora file." `date`
echo "******************************************************************************"

mkdir -p /u01/oradata/${ORACLE_SID^^}/pdbseed
mkdir -p /u01/oradata/${ORACLE_SID^^}/pdb1
mkdir -p ${ORACLE_BASE}/fast_recovery_area/${ORACLE_SID}
mkdir -p ${ORACLE_BASE}/admin/${ORACLE_SID}/adump

orapwd file=$ORACLE_HOME/dbs/orapw${ORACLE_SID} format=12 password=${SYS_PASSWORD} entries=10

cat > /tmp/init${NODE2_DB_UNIQUE_NAME}.ora <<EOF
*.db_name='${ORACLE_SID}'
*.local_listener='LISTENER'
EOF

echo "******************************************************************************"
echo "Create auxillary instance." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
--SHUTDOWN IMMEDIATE;
STARTUP NOMOUNT PFILE='/tmp/init${NODE2_DB_UNIQUE_NAME}.ora';
exit;
EOF


echo "******************************************************************************"
echo "Create standby database using RMAN duplicate." `date`
echo "******************************************************************************"
rman TARGET sys/${SYS_PASSWORD}@${NODE1_DB_UNIQUE_NAME} AUXILIARY sys/${SYS_PASSWORD}@${NODE2_DB_UNIQUE_NAME} <<EOF

DUPLICATE TARGET DATABASE
  FOR STANDBY
  FROM ACTIVE DATABASE
  DORECOVER
  SPFILE
    SET db_unique_name='${NODE2_DB_UNIQUE_NAME}' COMMENT 'Is standby'
  NOFILENAMECHECK;
  
exit;
EOF

echo "******************************************************************************"
echo "Enable the broker." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF

ALTER SYSTEM SET dg_broker_start=true;

EXIT;
EOF

echo "******************************************************************************"
echo "Configure broker (on primary) and display configuration." `date`
echo "******************************************************************************"
dgmgrl sys/${SYS_PASSWORD}@${NODE1_DB_UNIQUE_NAME} <<EOF

CREATE CONFIGURATION my_dg_config AS PRIMARY DATABASE IS ${NODE1_DB_UNIQUE_NAME} CONNECT IDENTIFIER IS ${NODE1_DB_UNIQUE_NAME};
ADD DATABASE ${NODE2_DB_UNIQUE_NAME} AS CONNECT IDENTIFIER IS ${NODE2_DB_UNIQUE_NAME} MAINTAINED AS PHYSICAL;
ENABLE CONFIGURATION;
SHOW CONFIGURATION;
SHOW DATABASE ${NODE1_DB_UNIQUE_NAME};
SHOW DATABASE ${NODE2_DB_UNIQUE_NAME};

EXIT;
EOF
