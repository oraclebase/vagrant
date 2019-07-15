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
  --components dbvserver,observer \
  --dbvserver-local-host ${CONSOLE_HOSTNAME} \
  --dbvserver-local-port 4433

echo "******************************************************************************"
echo "Start Dbvisit Console and Observer." `date`
echo "******************************************************************************"
/usr/dbvisit/dbvserver/dbvserver -d stop
/usr/dbvisit/dbvserver/dbvserver -d start
nohup /usr/dbvisit/observer/observersvc -f /usr/dbvisit/observer/conf/observer.conf &
