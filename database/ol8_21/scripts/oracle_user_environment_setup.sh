. /vagrant/config/install.env

echo "******************************************************************************"
echo "Create environment script." `date`
echo "******************************************************************************"
cat > ${SCRIPTS_DIR}/setEnv.sh <<EOF
# Regular settings.
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=`hostname`
export ORACLE_UNQNAME=${ORACLE_UNQNAME}
export ORACLE_BASE=${ORACLE_BASE}
export ORACLE_HOME=\$ORACLE_BASE/${ORACLE_HOME_EXT}
export ORACLE_SID=${ORACLE_SID}

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

export ORA_INVENTORY=${ORA_INVENTORY}


# Tomcat settings.
export JAVA_HOME=${JAVA_HOME}
export CATALINA_HOME=${CATALINA_HOME}
export CATALINA_BASE=${CATALINA_BASE}
export ORDS_CONFIG=${ORDS_CONF}
export JAVA_OPTS="-Dconfig.url=${ORDS_CONF} -Xms1126M -Xmx1126M"
export PATH=${ORDS_HOME}/bin:\$PATH
EOF


echo "******************************************************************************"
echo "Add it to the .bash_profile." `date`
echo "******************************************************************************"
echo ". ${SCRIPTS_DIR}/setEnv.sh" >> /home/oracle/.bash_profile


echo "******************************************************************************"
echo "Create start/stop scripts." `date`
echo "******************************************************************************"
. ${SCRIPTS_DIR}/setEnv.sh

cat > ${SCRIPTS_DIR}/start_all.sh <<EOF
#!/bin/bash
. ${SCRIPTS_DIR}/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF


cat > ${SCRIPTS_DIR}/stop_all.sh <<EOF
#!/bin/bash
. ${SCRIPTS_DIR}/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

# Add Tomcat management if required.
if [ "${INSTALL_ORDS}" = "true" ]; then
  
cat >> ${SCRIPTS_DIR}/start_all.sh <<EOF

\$CATALINA_HOME/bin/startup.sh
EOF

cat >> ${SCRIPTS_DIR}/stop_all.sh <<EOF

\$CATALINA_HOME/bin/shutdown.sh
EOF

fi

chown -R oracle.oinstall ${SCRIPTS_DIR}
chmod u+x ${SCRIPTS_DIR}/*.sh
