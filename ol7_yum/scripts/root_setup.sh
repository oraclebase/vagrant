sh /vagrant/scripts/prepare_u01_disk.sh
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

mkdir -p /var/www/html/repo/OracleLinux/ol7_latest
ln -s /u01/repo/OracleLinux/ol7_latest/getPackage/ /var/www/html/repo/OracleLinux/ol7_latest/x86_64

mkdir -p /var/www/html/repo/OracleLinux/ol7_UEKR4
ln -s /u01/repo/OracleLinux/ol7_UEKR4/getPackage/ /var/www/html/repo/OracleLinux/ol7_UEKR4/x86_64

mkdir -p /var/www/html/repo/OracleLinux/ol7_UEKR5
ln -s /u01/repo/OracleLinux/ol7_UEKR5/getPackage/ /var/www/html/repo/OracleLinux/ol7_UEKR5/x86_64

cp /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle /var/www/html/RPM-GPG-KEY-oracle-ol7
