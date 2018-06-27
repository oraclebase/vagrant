# One-off environment variables for build.
export SCRIPTS_DIR=/home/oracle/scripts
export SOFTWARE_DIR=/u01/software
export ORA_PASSWORD=OraPasswd1
export ORA_MEM=1536
export ORA_DATA_DIR=/u01/app/oracle/oradata/



# User environment setup.
mkdir -p ${SCRIPTS_DIR}
mkdir -p /u01/tmp

cat > ${SCRIPTS_DIR}/setEnv.sh <<EOF
# Oracle Settings
export TMP=/u01/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=${HOSTNAME}
export ORACLE_UNQNAME=cdb1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/12.2.0.1/db_1
export ORACLE_SID=cdb1
export PDB_NAME=pdb1

export PATH=/usr/sbin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

echo ". ${SCRIPTS_DIR}/setEnv.sh" >> /home/oracle/.bash_profile

. ${SCRIPTS_DIR}/setEnv.sh



# Unzip software.
mkdir -p ${SOFTWARE_DIR}
cd ${SOFTWARE_DIR}
unzip -o /vagrant/software/linuxx64_12201_database.zip



# Install software.
cd ${SOFTWARE_DIR}/database
./runInstaller -ignoreSysPrereqs -ignorePrereq -waitforcompletion -showProgress -silent \
    -responseFile ${SOFTWARE_DIR}/database/response/db_install.rsp \
    oracle.install.option=INSTALL_DB_SWONLY \
    ORACLE_HOSTNAME=${HOSTNAME} \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=/u01/app/oraInventory \
    SELECTED_LANGUAGES=en,en_GB \
    ORACLE_HOME=${ORACLE_HOME} \
    ORACLE_BASE=${ORACLE_BASE} \
    oracle.install.db.InstallEdition=EE \
    oracle.install.db.OSDBA_GROUP=dba \
    oracle.install.db.OSBACKUPDBA_GROUP=dba \
    oracle.install.db.OSDGDBA_GROUP=dba \
    oracle.install.db.OSKMDBA_GROUP=dba \
    oracle.install.db.OSRACDBA_GROUP=dba \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
    DECLINE_SECURITY_UPDATES=true



# Relink software.
cd $ORACLE_HOME/lib/stubs
mkdir BAK
mv libc* BAK/
$ORACLE_HOME/bin/relink all



# Create database.
dbca -silent -createDatabase \
     -templateName General_Purpose.dbc \
     -gdbname ${ORACLE_SID} -sid ${ORACLE_SID} -responseFile NO_VALUE \
     -characterSet AL32UTF8 \
     -sysPassword ${ORA_PASSWORD} \
     -systemPassword ${ORA_PASSWORD} \
     -createAsContainerDatabase true \
     -numberOfPDBs 1 \
     -pdbName ${PDB_NAME} \
     -pdbAdminPassword ${ORA_PASSWORD} \
     -databaseType MULTIPURPOSE \
     -automaticMemoryManagement false \
     -totalMemory ${ORA_MEM} \
     -storageType FS \
     -datafileDestination "${ORA_DATA_DIR}" \
     -redoLogFileSize 50 \
     -emConfiguration NONE \
     -ignorePreReqs



# Check DB status.
sqlplus / as sysdba <<EOF

ALTER SYSTEM SET DB_CREATE_FILE_DEST='${ORA_DATA_DIR}';
ALTER PLUGGABLE DATABASE ${PDB_NAME} SAVE STATE;

SELECT open_mode FROM v\$database;
 
EOF



# Set the autostart flag.
cp /etc/oratab /tmp
# Flip the auto-start flag.
sed -i -e "s|${ORACLE_SID}:${ORACLE_HOME}:N|${ORACLE_SID}:${ORACLE_HOME}:Y|g" /tmp/oratab
cp -f /tmp/oratab /etc/oratab 
