. /vagrant/config/install.env

if [ "${INSTALL_ORDS}" = "false" ]; then
  exit 0
fi

echo "******************************************************************************"
echo "Unpack all the software." `date`
echo "******************************************************************************"
# Java
mkdir -p /u01/java
cd /u01/java
tar -xzf /vagrant/software/${JAVA_SOFTWARE}
TEMP_FILE=`ls`
ln -s ${TEMP_FILE} latest

# Tomcat
mkdir -p /u01/tomcat
cd /u01/tomcat
tar -xzf /vagrant/software/${TOMCAT_SOFTWARE}
TEMP_FILE=`ls`
ln -s ${TEMP_FILE} latest

# CATALINA_BASE
mkdir -p ${CATALINA_BASE}
cp -r ${CATALINA_HOME}/conf $CATALINA_BASE
cp -r ${CATALINA_HOME}/logs $CATALINA_BASE
cp -r ${CATALINA_HOME}/temp $CATALINA_BASE
cp -r ${CATALINA_HOME}/webapps $CATALINA_BASE
cp -r ${CATALINA_HOME}/work $CATALINA_BASE

# ORDS
mkdir -p ${ORDS_HOME}
cd ${ORDS_HOME}
unzip -oq /vagrant/software/${ORDS_SOFTWARE}
mkdir -p ${ORDS_CONF}/logs

# SQLcl
cd /u01
unzip -oq /vagrant/software/${SQLCL_SOFTWARE}
cd ${SOFTWARE_DIR}

# APEX Images
rm -Rf ${CATALINA_BASE}/webapps/*
mkdir -p ${CATALINA_BASE}/webapps/i/
cp -R ${SOFTWARE_DIR}/apex/images/* ${CATALINA_BASE}/webapps/i/


echo "******************************************************************************"
echo "Configure ORDS. Safe to run on DB with existing config." `date`
echo "******************************************************************************"
cd ${ORDS_HOME}

export ORDS_CONFIG=${ORDS_CONF}
${ORDS_HOME}/bin/ords --config ${ORDS_CONF} install \
     --log-folder ${ORDS_CONF}/logs \
     --admin-user SYS \
     --db-hostname ${HOSTNAME} \
     --db-port ${DB_PORT} \
     --db-servicename ${DB_SERVICE} \
     --feature-db-api true \
     --feature-rest-enabled-sql true \
     --feature-sdw true \
     --gateway-mode proxied \
     --gateway-user APEX_PUBLIC_USER \
     --proxy-user \
     --password-stdin <<EOF
${SYS_PASSWORD}
${ORDS_PASSWORD}
EOF

cp ords.war ${CATALINA_BASE}/webapps/


echo "******************************************************************************"
echo "Configure HTTPS." `date`
echo "******************************************************************************"
if [ ! -f ${KEYSTORE_DIR}/keystore.jks ]; then
  mkdir -p ${KEYSTORE_DIR}
  cd ${KEYSTORE_DIR}
  ${JAVA_HOME}/bin/keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks \
     -dname "CN=${HOSTNAME}, OU=My Department, O=My Company, L=Birmingham, ST=West Midlands, C=GB" \
     -storepass ${KEYSTORE_PASSWORD} -validity 3600 -keysize 2048 -keypass ${KEYSTORE_PASSWORD}
  cp /vagrant/scripts/server.xml ${CATALINA_BASE}/conf/
  cp /vagrant/scripts/web.xml ${CATALINA_BASE}/conf/
  sed -i -e "s|###KEYSTORE_DIR###|${KEYSTORE_DIR}|g" ${CATALINA_BASE}/conf/server.xml
  sed -i -e "s|###KEYSTORE_PASSWORD###|${KEYSTORE_PASSWORD}|g" ${CATALINA_BASE}/conf/server.xml
  sed -i -e "s|###AJP_SECRET###|${AJP_SECRET}|g" ${CATALINA_BASE}/conf/server.xml
  sed -i -e "s|###AJP_ADDRESS###|${AJP_ADDRESS}|g" ${CATALINA_BASE}/conf/server.xml
fi;


echo "******************************************************************************"
echo "Restart everything." `date`
echo "******************************************************************************"
${SCRIPTS_DIR}/stop_all.sh
# Get rid of start, as this is none done using the service.
#${SCRIPTS_DIR}/start_all.sh
