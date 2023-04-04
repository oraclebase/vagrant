. /vagrant/config/install.env

echo "******************************************************************************"
echo "Create default database." `date`
echo "******************************************************************************"
(echo "${DB_PASSWORD}"; echo "${DB_PASSWORD}";) | /etc/init.d/oracle-free-23c configure