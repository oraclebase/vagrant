. /vagrant_config/install.env

echo "******************************************************************************"
echo "Configure Dbvisit." `date`
echo "******************************************************************************"

mkdir -p ~/9.0
cd ~/9.0
cp /vagrant_software/dbvisit-standby*.zip .
unzip -oq dbvisit-standby*.zip
tar xf dbvisit-standby*.tar
cd dbvisit/installer

./install-dbvisit --batch-install \
  --force \
  --dbvisit-base /usr/dbvisit \
  --components core \
  --dbvnet-local-host ${NODE2_HOSTNAME} \
  --dbvnet-local-port 7890 \
  --dbvnet-remote-host ${NODE1_HOSTNAME} \
  --dbvnet-remote-port 7890 \
  --dbvnet-passphrase ${DBVISIT_PASSPHRASE} \
  --dbvagent-local-host ${NODE2_HOSTNAME} \
  --dbvagent-local-port 7891 \
  --dbvagent-passphrase ${DBVISIT_PASSPHRASE}

echo "******************************************************************************"
echo "Start Dbvisit Console." `date`
echo "******************************************************************************"
/usr/dbvisit/dbvnet/dbvnet -d stop
/usr/dbvisit/dbvagent/dbvagent -d stop
/usr/dbvisit/dbvnet/dbvnet -d start
/usr/dbvisit/dbvagent/dbvagent -d start
