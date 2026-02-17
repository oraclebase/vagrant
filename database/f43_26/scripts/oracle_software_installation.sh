. /vagrant/config/install.env

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_HOME}
cd ${ORACLE_HOME}
unzip -oq /vagrant/software/${DB_SOFTWARE}

# Fix suggested by Steven Kennedy.
#cd ${ORACLE_HOME}/lib/stubs
#mv libc.so libc.so.hide
#mv libc.so.6 libc.so.6.hide
#cd ${ORACLE_HOME}

echo "******************************************************************************"
echo "Do software-only installation." `date`
echo "******************************************************************************"
# Fake OS.
export CV_ASSUME_DISTID=OEL9.7

./runInstaller -ignorePrereq -waitforcompletion -silent              \
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
