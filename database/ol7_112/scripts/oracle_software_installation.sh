. /vagrant/config/install.env

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_HOME}
cd ${SOFTWARE_DIR}
unzip -oq "/vagrant/software/${DB_SOFTWARE}"

echo "******************************************************************************"
echo "Do software-only installation." `date`
echo "******************************************************************************"
# Use oraInst.loc, to get around bug using ORA_INVENTORY with runInstaller.
cat > $ORACLE_BASE/oraInst.loc <<EOF
inventory_loc=${ORA_INVENTORY}
inst_group=oinstall
EOF

${SOFTWARE_DIR}/database/runInstaller -ignoreSysPrereqs -ignorePrereq          \
    -waitforcompletion -silent                                                 \
    -responseFile ${SOFTWARE_DIR}/database/response/db_install.rsp             \
    -invPtrLoc ${ORACLE_BASE}/oraInst.loc                                      \
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
