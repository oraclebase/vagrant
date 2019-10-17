echo "******************************************************************************"
echo "Configure Spacewalk." `date`
echo "******************************************************************************"

echo "******************************************************************************"
echo "Create answer file." `date`
echo "******************************************************************************"

cat > /tmp/answer-file.txt <<EOF
admin-email = root@localhost
ssl-set-cnames = spacewalk2
ssl-set-org = Spacewalk Org
ssl-set-org-unit = spacewalk
ssl-set-city = My City
ssl-set-state = My State
ssl-set-country = US
ssl-password = spacewalk
ssl-set-email = root@localhost
ssl-config-sslvhost = Y
db-backend=postgresql
db-name=spaceschema
db-user=spaceuser
db-password=spacepw
db-host=localhost
db-port=5432
enable-tftp=Y
EOF

echo "******************************************************************************"
echo "Initialise database." `date`
echo "******************************************************************************"

rm -Rf /var/lib/pgsql/data
postgresql-setup initdb

echo "******************************************************************************"
echo "Spacewalk setup." `date`
echo "******************************************************************************"

# Now run normal config.
spacewalk-setup --answer-file=/tmp/answer-file.txt
