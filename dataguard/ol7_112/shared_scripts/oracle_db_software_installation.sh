. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip database software." `date`
echo "******************************************************************************"
mkdir -p /u01/software
cd /u01/software
unzip -oq "/vagrant_software/${DB_SOFTWARE}"
cd database

cat > /u01/software/oraInst.loc <<EOF
inventory_loc=${ORA_INVENTORY}
inst_group=oinstall
EOF

echo "******************************************************************************"
echo "Do database software-only installation." `date`
echo "******************************************************************************"
./runInstaller -ignoreSysPrereqs -ignorePrereq                                 \
    -waitforcompletion -silent                                                 \
    -responseFile /u01/software/database/response/db_install.rsp               \
    -invPtrLoc /u01/software/oraInst.loc                                       \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.DBA_GROUP=dba                                            \
    oracle.install.db.OPER_GROUP=dba                                           \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true