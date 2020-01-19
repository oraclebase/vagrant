. /vagrant_config/install.env

echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

sh /vagrant_scripts/configure_hosts_base.sh
sh /vagrant_scripts/configure_hosts_scan.sh

echo "******************************************************************************"
echo "Install dnsmasq." `date`
echo "******************************************************************************"

 yum -y install dnsmasq  
systemctl enable dnsmasq
systemctl restart dnsmasq
