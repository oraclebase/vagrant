export PATH=${ORACLE_HOME}/OPatch:${PATH}
export PATCH_TOP=${SOFTWARE_DIR}/30463595
export PATCH_PATH1=${PATCH_TOP}/30557433
export PATCH_PATH2=${PATCH_TOP}/30484981
export OPATCH_FILE="p6880880_190000_Linux-x86-64.zip"
export PATCH_FILE="p30463595_190000_Linux-x86-64.zip"

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"
cd ${ORACLE_HOME}
unzip -oq ${SOFTWARE_DIR}/${OPATCH_FILE}

cd ${SOFTWARE_DIR}
unzip -oq ${PATCH_FILE}

echo "******************************************************************************"
echo "Shutdown database." `date`
echo "******************************************************************************"
dbshut ${ORACLE_HOME}

echo "******************************************************************************"
echo "Run Patches." `date`
echo "******************************************************************************"
cd ${PATCH_PATH1}
opatch prereq CheckConflictAgainstOHWithDetail -ph ./
opatch apply -silent

cd ${PATCH_PATH2}
opatch prereq CheckConflictAgainstOHWithDetail -ph ./
opatch apply -silent

echo "******************************************************************************"
echo "Start listener." `date`
echo "******************************************************************************"
lsnrctl start

echo "******************************************************************************"
echo "Prepare CDB and PDB." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
startup upgrade;
alter pluggable database all open upgrade;
exit;
EOF

echo "******************************************************************************"
echo "Run datapatch." `date`
echo "******************************************************************************"
cd $ORACLE_HOME/OPatch
./datapatch -verbose

echo "******************************************************************************"
echo "Restart database." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
shutdown immediate;
startup;
alter pluggable database all open;
exit;
EOF

echo "******************************************************************************"
echo "Compile invalid objects." `date`
echo "******************************************************************************"
$ORACLE_HOME/perl/bin/perl \
    -I$ORACLE_HOME/perl/lib \
    -I$ORACLE_HOME/rdbms/admin \
    $ORACLE_HOME/rdbms/admin/catcon.pl \
    -l /tmp/ \
    -b postpatch_${ORACLE_SID}_recompile \
    -C 'PDB$SEED' \
    $ORACLE_HOME/rdbms/admin/utlrp.sql
