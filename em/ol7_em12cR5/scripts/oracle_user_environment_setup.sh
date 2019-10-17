echo "******************************************************************************"
echo "Create environment script." `date`
echo "******************************************************************************"
mkdir -p /home/oracle/scripts

cat > /home/oracle/scripts/setEnv.sh <<EOF
# Regular settings.
export TMP=/u01/tmp
export TMPDIR=\${TMP}

export ORACLE_HOSTNAME=${HOSTNAME}
export ORACLE_UNQNAME=emcdb
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\${ORACLE_BASE}/product/12.1.0.2/dbhome_1
export ORACLE_SID=emcdb

export PATH=/usr/sbin:/usr/local/bin:\${PATH}
export PATH=\${ORACLE_HOME}/bin:\${PATH}

export LD_LIBRARY_PATH=\${ORACLE_HOME}/lib:/lib:/usr/lib
export CLASSPATH=\${ORACLE_HOME}/jlib:\${ORACLE_HOME}/rdbms/jlib

export ORA_INVENTORY=/u01/app/oraInventory


# Database installation settings.
export SOFTWARE_DIR=/u01/software
export DB_SOFTWARE="linuxamd64_12102_database_*of2.zip"
export ORACLE_PASSWORD="oracle"
export SCRIPTS_DIR=/home/oracle/scripts

export ORACLE_SID=emcdb
export SYS_PASSWORD="SysPassword1"
export PDB_NAME="emrep"
export PDB_PASSWORD="PdbPassword1"
export DATA_DIR=/u01/oradata

# EM settings.
export UNIX_GROUP_NAME=oinstall
export MW_HOME=\${ORACLE_BASE}/middleware
export OMS_HOME=\${MW_HOME}/oms
export GC_INST=\${ORACLE_BASE}/gc_inst
export AGENT_BASE=\${ORACLE_BASE}/agent
export AGENT_HOME=\${AGENT_BASE}/agent_inst
export WLS_USERNAME=weblogic
export WLS_PASSWORD=Welcome1
export SYSMAN_PASSWORD=\${WLS_PASSWORD}
export AGENT_PASSWORD=\${WLS_PASSWORD}
export SOFTWARE_LIBRARY=\${ORACLE_BASE}/swlib
export DATABASE_HOSTNAME=localhost
export LISTENER_PORT=1521

EOF


echo "******************************************************************************"
echo "Add it to the .bash_profile." `date`
echo "******************************************************************************"
echo ". /home/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile


echo "******************************************************************************"
echo "Create start/stop scripts." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh

cat > $SCRIPTS_DIR/start_all.sh <<EOF
#!/bin/bash
. $SCRIPTS_DIR/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
dbstart \$ORACLE_HOME

\$SCRIPTS_DIR/start_cloud_control.sh
EOF


cat > $SCRIPTS_DIR/stop_all.sh <<EOF
#!/bin/bash
. $SCRIPTS_DIR/setEnv.sh

\$SCRIPTS_DIR/stop_cloud_control.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
dbshut \$ORACLE_HOME
EOF


cat > $SCRIPTS_DIR/start_cloud_control.sh <<EOF
#!/bin/bash
. $SCRIPTS_DIR/setEnv.sh

\$OMS_HOME/bin/emctl start oms

\$AGENT_HOME/bin/emctl start agent
EOF


cat > $SCRIPTS_DIR/stop_cloud_control.sh <<EOF
#!/bin/bash
. $SCRIPTS_DIR/setEnv.sh

\$AGENT_HOME/bin/emctl stop agent

\$OMS_HOME/bin/emctl stop oms -all
EOF


chown -R oracle.oinstall ${SCRIPTS_DIR}
chmod u+x ${SCRIPTS_DIR}/*.sh
