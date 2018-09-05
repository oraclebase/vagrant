. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
mkdir /u01/software
cd /u01/software
unzip -oq /vagrant_software/${DB_SOFTWARE}
cd database

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
./runInstaller -ignorePrereq -waitforcompletion -silent \
        -responseFile /u01/software/database/response/db_install.rsp \
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
