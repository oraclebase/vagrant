echo "******************************************************************************"
echo "Create environment script." `date`
echo "******************************************************************************"
cat > /home/oracle/scripts/setEnv.sh <<EOF
# Regular settings.
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=`hostname`
export ORACLE_UNQNAME=db11g
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0.1/db_1
export ORACLE_SID=db11g

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

export ORA_INVENTORY=/u01/app/oraInventory


# Database installation settings.
export SOFTWARE_DIR=/u01/software
export DB_SOFTWARE="linux.x64_11gR2_database_*of2.zip"
export APEX_SOFTWARE="apex_18.2_en.zip"
export ORACLE_PASSWORD="oracle"
export SCRIPTS_DIR=/home/oracle/scripts

export ORACLE_SID=db11g
export SYS_PASSWORD="SysPassword1"
export APEX_EMAIL="me@example.com"
export APEX_PASSWORD="ApexPassword1"
export DATA_DIR=/u02/oradata


# ORDS installation settings.
export JAVA_SOFTWARE="openjdk-11.0.1_linux-x64_bin.tar.gz"
export TOMCAT_SOFTWARE="apache-tomcat-9.0.12.tar.gz"
export ORDS_SOFTWARE="ords-18.3.0.270.1456.zip"
export APEX_SOFTWARE="apex_18.2_en.zip"
export SQLCL_SOFTWARE="sqlcl-18.3.0.259.2029.zip"
export SOFTWARE_DIR="/u01/software"
export KEYSTORE_DIR="/u01/keystore"
export ORDS_HOME="/u01/ords"
export ORDS_CONF="/u01/ords/conf"
export JAVA_HOME="/u01/java"
export CATALINA_HOME="/u01/tomcat"
export CATALINA_BASE=\$CATALINA_HOME

export DB_PORT="1521"
export DB_SERVICE="db11g"
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

\$CATALINA_BASE/bin/startup.sh
EOF


cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

\$CATALINA_BASE/bin/shutdown.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

chown -R oracle.oinstall ${SCRIPTS_DIR}
chmod u+x ${SCRIPTS_DIR}/*.sh
