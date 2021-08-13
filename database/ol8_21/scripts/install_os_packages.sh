echo "******************************************************************************"
echo "Install OS Packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y dnf-utils zip unzip

dnf install -y oracle-database-preinstall-19c


echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld


echo "******************************************************************************"
echo "SELinux." `date`
echo "******************************************************************************"
sed -i -e "s|SELINUX=enabled|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive
