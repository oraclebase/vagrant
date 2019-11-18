. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/oracle/scripts

cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=${NODE1_FQ_HOSTNAME}
export ORACLE_BASE=${ORACLE_BASE}
export ORA_INVENTORY=${ORA_INVENTORY}
export ORACLE_HOME=\$ORACLE_BASE/${ORACLE_HOME_EXT}
export ORACLE_SID=${ORACLE_SID}
export DATA_DIR=${DATA_DIR}
export ORACLE_TERM=xterm
export BASE_PATH=/usr/sbin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$BASE_PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

cat >> /home/oracle/.bash_profile <<EOF
. /home/oracle/scripts/setEnv.sh
EOF

echo "******************************************************************************"
echo "Create directories." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh
mkdir -p ${ORACLE_HOME}
mkdir -p ${DATA_DIR}

echo "******************************************************************************"
echo "Create start/stop scripts." `date`
echo "******************************************************************************"


cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

db_type=`cat /home/oracle/scripts/db_type.txt`
if [ "$db_type" == "Primary" ] ; then
# open primary DB
${ORACLE_HOME}/bin/sqlplus "/ as sysdba" <<EOF
startup mount
exit
EOF
# mount standby DB
else echo  "$result"
${ORACLE_HOME}/bin/sqlplus "/ as sysdba" <<EOF
startup 
exit
EOF
fi
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart $ORACLE_HOME
EOF


cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh
/home/oracle/scripts/check_dgmgrl.sh
echo "show configuration;" |$ORACLE_HOME/bin/dgmgrl / |grep -A 1 "$ORACLE_SID" |awk 'NR==1 {print $3}' > /home/oracle/scripts/db_type.txt
db_type=`cat /home/oracle/scripts/db_type.txt`
echo  $ORACLE_SID is a $db_type DB
export ORAENV_ASK=NO
. oraenv
#dbshut $ORACLE_HOME
EOF

cat > /home/oracle/scripts/check_dgmgrl.sh <<EOF
#!/bin/bash
. /home/oracle/.bash_profile
result=`echo "show configuration;" | \
  $ORACLE_HOME/bin/dgmgrl / | \
  grep -A 1 "Configuration Status" | grep -v "Configuration Status"|awk '{print $1}'`
if [ "$result" == "SUCCESS" ] ; then
 echo 'Data Guard status : up '
else echo  "$result"
fi
EOF

chown -R oracle.oinstall ${SCRIPTS_DIR}
chmod u+x ${SCRIPTS_DIR}/*.sh
