. /vagrant_config/install.env

echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
#cd /etc/yum.repos.d
#rm -f public-yum-ol7.repo
#wget https://yum.oracle.com/public-yum-ol7.repo

sh /vagrant_scripts/configure_hosts_base.sh
sh /vagrant_scripts/configure_hosts_scan.sh

echo "******************************************************************************"
echo "Install dnsmasq." `date`
echo "******************************************************************************"

cat > /etc/yum.repos.d/oracle-linux-ol8.repo <<EOF  
[ol-8-for-x86_64-baseos-beta-rpms]
name = Oracle Enterprise Linux 8 for x86_64 - BaseOS Beta (RPMs)
baseurl = https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/
enabled = 1
gpgcheck = 0

[ol-8-for-x86_64-appstream-beta-rpms]
name = Oracle Enterprise Linux 8 for x86_64 - AppStream Beta (RPMs)
baseurl = https://yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/
enabled = 1
gpgcheck = 0
EOF

# yum-config-manager --enable ol8_latest
 yum -y install dnsmasq  
systemctl enable dnsmasq
systemctl restart dnsmasq
