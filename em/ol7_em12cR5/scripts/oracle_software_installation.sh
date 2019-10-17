echo "Unzip software." `date`
echo "******************************************************************************"
cd ${SOFTWARE_DIR}
unzip -oq "${DB_SOFTWARE}"
cd database

echo "******************************************************************************"
echo "Do software-only installation." `date`
echo "******************************************************************************"
./runInstaller -ignorePrereq -waitforcompletion -silent                        \
    -responseFile ${SOFTWARE_DIR}/database/response/db_install.rsp             \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.DBA_GROUP=dba                                            \
    oracle.install.db.BACKUPDBA_GROUP=dba                                      \
    oracle.install.db.DGDBA_GROUP=dba                                          \
    oracle.install.db.KMDBA_GROUP=dba                                          \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true
