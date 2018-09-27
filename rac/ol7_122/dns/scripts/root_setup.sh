. /vagrant_config/install.env

echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
cd /etc/yum.repos.d
#rm -f public-yum-ol6.repo
#wget http://yum.oracle.com/public-yum-ol6.repo
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo

sh /vagrant_scripts/configure_hosts_base.sh
sh /vagrant_scripts/configure_hosts_scan.sh

echo "******************************************************************************"
echo "Install dnsmasq." `date`
echo "******************************************************************************"
yum install -y dnsmasq
systemctl enable dnsmasq
systemctl restart dnsmasq
