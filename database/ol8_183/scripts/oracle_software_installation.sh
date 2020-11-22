. /vagrant/config/install.env

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_HOME}
cd ${ORACLE_HOME}
unzip -oq /vagrant/software/${DB_SOFTWARE}

echo "******************************************************************************"
echo "Do software-only installation." `date`
echo "******************************************************************************"
export CV_ASSUME_DISTID=OEL7.6

${ORACLE_HOME}/runInstaller -ignorePrereq -waitforcompletion -silent           \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true
