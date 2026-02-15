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
export CV_ASSUME_DISTID=OEL9.7

${ORACLE_HOME}/runInstaller -ignorePrereq -waitforcompletion -silent \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp     \
    installOption=INSTALL_DB_SWONLY                                  \
    UNIX_GROUP_NAME=oinstall                                         \
    INVENTORY_LOCATION=${ORA_INVENTORY}                              \
    ORACLE_HOME=${ORACLE_HOME}                                       \
    ORACLE_BASE=${ORACLE_BASE}                                       \
    installEdition=EE                                                \
    OSDBA=dba                                                        \
    OSBACKUPDBA=dba                                                  \
    OSDGDBA=dba                                                      \
    OSKMDBA=dba                                                      \
    OSRACDBA=dba
