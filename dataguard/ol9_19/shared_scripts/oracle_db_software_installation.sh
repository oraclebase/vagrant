. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_HOME}
cd ${ORACLE_HOME}
unzip -oq /vagrant_software/${DB_SOFTWARE}
unzip -oq /vagrant_software/${OPATCH_FILE}

mkdir -p ${SOFTWARE_DIR}
cd ${SOFTWARE_DIR}
unzip -oq /vagrant_software/${PATCH_FILE}

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
# Fake Oracle Linux 8.
# Should not be necessary, but the installation fails without it on 19.21 DB RU + OJVM combo.
export CV_ASSUME_DISTID=OL8

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
        SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
        DECLINE_SECURITY_UPDATES=true
