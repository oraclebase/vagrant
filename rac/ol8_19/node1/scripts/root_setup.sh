echo "******************************************************************************"
echo "Setup Start." `date`
echo "******************************************************************************"

. /vagrant_config/install.env

sh /vagrant_scripts/prepare_u01_disk.sh

sh /vagrant_scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
mkdir -p ${SOFTWARE_DIR}
chown -R oracle:oinstall /u01
chmod -R 775 /u01
usermod -aG vagrant oracle

sh /vagrant_scripts/configure_hosts_base.sh

cat > /etc/resolv.conf <<EOF
search localdomain
nameserver ${DNS_PUBLIC_IP}
EOF

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

sh /vagrant_scripts/configure_chrony.sh

sh /vagrant_scripts/configure_shared_disks.sh

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname ${NODE1_HOSTNAME}

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

echo "******************************************************************************"
echo "Passwordless SSH Setup for root." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE1_HOSTNAME} date
echo "${ROOT_PASSWORD}" > /tmp/temp1.txt

ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE2_HOSTNAME}

cat > /tmp/ssh-setup.sh <<EOF
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE1_HOSTNAME}
EOF

ssh ${NODE2_HOSTNAME} 'bash -s' < /tmp/ssh-setup.sh

echo "******************************************************************************"
echo "Install cvuqdisk package." `date`
echo "******************************************************************************"
yum install -y ${GRID_HOME}/cv/rpm/cvuqdisk-1.0.10-1.rpm
ssh root@${NODE2_HOSTNAME} yum install -y /tmp/cvuqdisk-1.0.10-1.rpm

su - oracle -c 'sh /vagrant/scripts/oracle_grid_software_installation.sh'

echo "******************************************************************************"
echo "Run grid root scripts." `date`
echo "******************************************************************************"
sh ${ORA_INVENTORY}/orainstRoot.sh
ssh root@${NODE2_HOSTNAME} sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${GRID_HOME}/root.sh
ssh root@${NODE2_HOSTNAME} sh ${GRID_HOME}/root.sh

su - oracle -c 'sh /vagrant/scripts/oracle_grid_software_config.sh'

su - oracle -c 'sh /vagrant/scripts/oracle_db_software_installation.sh'

echo "******************************************************************************"
echo "Run DB root scripts." `date` 
echo "******************************************************************************"
sh ${ORACLE_HOME}/root.sh
ssh root@${NODE2_HOSTNAME} sh ${ORACLE_HOME}/root.sh

echo "******************************************************************************"
echo "OJVM Patch for DB Software." `date`
echo "******************************************************************************"
sh /vagrant_scripts/oracle_software_patch.sh ${ORACLE_HOME}
ssh root@${NODE2_HOSTNAME} sh /vagrant_scripts/oracle_software_patch.sh ${ORACLE_HOME}

su - oracle -c 'sh /vagrant/scripts/oracle_create_database.sh'

echo "******************************************************************************"
echo "Setup End." `date`
echo "******************************************************************************"
