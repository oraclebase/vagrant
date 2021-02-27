sh /vagrant/scripts/prepare_disks.sh
sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Make repo directories." `date`
echo "******************************************************************************"
mkdir -p /u01/repo/OracleLinux
mkdir -p /u01/repo/logs
mkdir -p /u01/repo/scripts

echo "******************************************************************************"
echo "Make repo directories." `date`
echo "******************************************************************************"
cp /vagrant/scripts/repo_sync.sh /u01/repo/scripts/
chmod u+x /u01/repo/scripts/*.sh
sh /u01/repo/scripts/repo_sync.sh

echo "******************************************************************************"
echo "Configure Apache." `date`
echo "******************************************************************************"
systemctl start httpd
systemctl enable httpd

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

mkdir -p /var/www/html/repo/OracleLinux/ol8_baseos_latest
ln -s /u01/repo/OracleLinux/ol8_baseos_latest/getPackage/ /var/www/html/repo/OracleLinux/ol8_baseos_latest/x86_64

mkdir -p /var/www/html/repo/OracleLinux/ol8_UEKR6
ln -s /u01/repo/OracleLinux/ol8_UEKR6/getPackage/ /var/www/html/repo/OracleLinux/ol8_UEKR6/x86_64

cp /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle /var/www/html/RPM-GPG-KEY-oracle-ol8
