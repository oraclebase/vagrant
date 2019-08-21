. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
mkdir -p ${SOFTWARE_DIR}
cd ${SOFTWARE_DIR}
unzip -oq "/vagrant_software/${DB_SOFTWARE}"
cd database

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
./runInstaller -ignorePrereq -waitforcompletion -silent \
        -responseFile ${SOFTWARE_DIR}/database/response/db_install.rsp \
        oracle.install.option=INSTALL_DB_SWONLY \
        UNIX_GROUP_NAME=oinstall \
        INVENTORY_LOCATION=${ORA_INVENTORY} \
        SELECTED_LANGUAGES=${ORA_LANGUAGES} \
        ORACLE_HOME=${ORACLE_HOME} \
        ORACLE_BASE=${ORACLE_BASE} \
        oracle.install.db.InstallEdition=EE \
        oracle.install.db.DBA_GROUP=dba \
        oracle.install.db.BACKUPDBA_GROUP=dba \
        oracle.install.db.DGDBA_GROUP=dba \
        oracle.install.db.KMDBA_GROUP=dba \
        oracle.install.db.CLUSTER_NODES=${NODE1_HOSTNAME},${NODE2_HOSTNAME} \
        oracle.install.db.config.starterdb.type=GENERAL_PURPOSE \
        SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
        DECLINE_SECURITY_UPDATES=true
