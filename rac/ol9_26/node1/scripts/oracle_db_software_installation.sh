. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
cd ${ORACLE_HOME}
unzip -oq /vagrant_software/${DB_SOFTWARE}

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
${ORACLE_HOME}/runInstaller -ignorePrereq -waitforcompletion -silent \
        -responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
        installOption=INSTALL_DB_SWONLY \
        ORACLE_HOSTNAME=${ORACLE_HOSTNAME} \
        UNIX_GROUP_NAME=oinstall \
        INVENTORY_LOCATION=${ORA_INVENTORY} \
        SELECTED_LANGUAGES=${ORA_LANGUAGES} \
        ORACLE_HOME=${ORACLE_HOME} \
        ORACLE_BASE=${ORACLE_BASE} \
        installEdition=EE \
        OSDBA=dba \
        OSBACKUPDBA=dba \
        OSDGDBA=dba \
        OSKMDBA=dba \
        OSRACDBA=dba \
        clusterNodes=${NODE1_HOSTNAME},${NODE2_HOSTNAME} \
        dbType=GENERAL_PURPOSE
