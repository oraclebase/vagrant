echo "******************************************************************************"
echo "Create the database auto-start service." `date`
echo "******************************************************************************"
cp /vagrant/scripts/dbora.service /lib/systemd/system/dbora.service
systemctl daemon-reload
systemctl start dbora.service
systemctl enable dbora.service
