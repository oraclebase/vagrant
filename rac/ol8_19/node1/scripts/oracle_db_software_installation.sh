. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
cd ${ORACLE_HOME}
unzip -oq /vagrant_software/${DB_SOFTWARE}
unzip -oq /vagrant_software/${OPATCH_FILE}

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
${ORACLE_HOME}/runInstaller -ignorePrereq -waitforcompletion -silent \
        -applyRU ${PATCH_PATH1} \
        -responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
        oracle.install.option=INSTALL_DB_SWONLY \
        ORACLE_HOSTNAME=${ORACLE_HOSTNAME} \
        UNIX_GROUP_NAME=oinstall \
        INVENTORY_LOCATION=${ORA_INVENTORY} \
        SELECTED_LANGUAGES=${ORA_LANGUAGES} \
        ORACLE_HOME=${ORACLE_HOME} \
        ORACLE_BASE=${ORACLE_BASE} \
        oracle.install.db.InstallEdition=EE \
        oracle.install.db.OSDBA_GROUP=dba \
        oracle.install.db.OSBACKUPDBA_GROUP=dba \
        oracle.install.db.OSDGDBA_GROUP=dba \
        oracle.install.db.OSKMDBA_GROUP=dba \
        oracle.install.db.OSRACDBA_GROUP=dba \
        oracle.install.db.CLUSTER_NODES=${NODE1_HOSTNAME},${NODE2_HOSTNAME} \
        oracle.install.db.isRACOneInstall=false \
        oracle.install.db.rac.serverpoolCardinality=0 \
        oracle.install.db.config.starterdb.type=GENERAL_PURPOSE \
        oracle.install.db.ConfigureAsContainerDB=false \
        SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
        DECLINE_SECURITY_UPDATES=true
