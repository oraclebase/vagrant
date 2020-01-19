. /vagrant_config/install.env

sh /vagrant_scripts/prepare_u01_disk.sh

sh /vagrant_scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01

sh /vagrant_scripts/configure_hosts_base.sh

cat > /etc/resolv.conf <<EOF
search ${DOMAIN_NAME}
nameserver ${DNS_PUBLIC_IP}
EOF

sh /vagrant_scripts/configure_chrony.sh

sh /vagrant_scripts/configure_shared_disks.sh

#sudo sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/2" /etc/ssh/sshd_config

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

sh /vagrant_scripts/configure_hostname.sh

echo "******************************************************************************"
echo "Passwordless SSH Setup for root." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh ${NODE2_HOSTNAME} date
echo "${ROOT_PASSWORD}" > /tmp/temp1.txt
