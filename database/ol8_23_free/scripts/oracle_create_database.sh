. /vagrant/config/install.env

echo "******************************************************************************"
echo "Create default database." `date`
echo "******************************************************************************"
(echo "${DB_PASSWORD}"; echo "${DB_PASSWORD}";) | /etc/init.d/oracle-free-23c configure


echo "******************************************************************************"
echo "Flip the auto-start flag." `date`
echo "******************************************************************************"
cp /etc/oratab /tmp
sed -i -e "s|${ORACLE_SID}:${ORACLE_HOME}:N|${ORACLE_SID}:${ORACLE_HOME}:Y|g" /tmp/oratab
cp -f /tmp/oratab /etc/oratab
