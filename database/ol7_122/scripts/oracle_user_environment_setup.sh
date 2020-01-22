echo "******************************************************************************"
echo "Create environment script." `date`
echo "******************************************************************************"
cat > /home/oracle/scripts/setEnv.sh <<EOF
# Regular settings.
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=`hostname`
export ORACLE_UNQNAME=cdb1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/12.2.0.1/db_1
export ORACLE_SID=cdb1

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

export ORA_INVENTORY=/u01/app/oraInventory


# Database installation settings.
export SOFTWARE_DIR=/u01/software
export DB_SOFTWARE="linuxx64_12201_database.zip"
export APEX_SOFTWARE="apex_19.2_en.zip"
export ORACLE_PASSWORD="oracle"
export SCRIPTS_DIR=/home/oracle/scripts

export ORACLE_SID=cdb1
export SYS_PASSWORD="SysPassword1"
export PDB_NAME="pdb1"
export PDB_PASSWORD="PdbPassword1"
export APEX_EMAIL="me@example.com"
export APEX_PASSWORD="ApexPassword1"
export DATA_DIR=/u02/oradata

export INSTALL_APEX="true"


# ORDS installation settings.
export JAVA_SOFTWARE="OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz"
export TOMCAT_SOFTWARE="apache-tomcat-9.0.30.tar.gz"
export ORDS_SOFTWARE="ords-19.4.0.352.1226.zip"
export SQLCL_SOFTWARE="sqlcl-19.4.0.354.0937.zip"
export SOFTWARE_DIR="/u01/software"
export KEYSTORE_DIR="/u01/keystore"
export ORDS_HOME="/u01/ords"
export ORDS_CONF="/u01/ords/conf"
export JAVA_HOME="/u01/java/latest"
export CATALINA_HOME="/u01/tomcat/latest"
export CATALINA_BASE="/u01/config/instance1"

export DB_PORT="1521"
export DB_SERVICE="pdb1"
export APEX_PUBLIC_USER_PASSWORD="ApexPassword1"
export APEX_TABLESPACE="APEX"
export TEMP_TABLESPACE="TEMP"
export APEX_LISTENER_PASSWORD="ApexPassword1"
export APEX_REST_PASSWORD="ApexPassword1"
export PUBLIC_PASSWORD="ApexPassword1"
export SYS_PASSWORD="SysPassword1"
export KEYSTORE_PASSWORD="KeystorePassword1"
EOF


echo "******************************************************************************"
echo "Add it to the .bash_profile." `date`
echo "******************************************************************************"
echo ". /home/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile


echo "******************************************************************************"
echo "Create start/stop scripts." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh

cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME

\$CATALINA_HOME/bin/startup.sh
EOF


cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

\$CATALINA_HOME/bin/shutdown.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

chown -R oracle.oinstall ${SCRIPTS_DIR}
chmod u+x ${SCRIPTS_DIR}/*.sh
