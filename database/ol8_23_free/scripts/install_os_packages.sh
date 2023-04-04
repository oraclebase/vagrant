echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y dnf-utils zip unzip

echo "******************************************************************************"
echo "Install Oracle prerequisite package." `date`
echo "Not necessary, but oracle OS user has no home directory if this is not run first."
echo "******************************************************************************"
dnf install -y oraclelinux-developer-release-el8
dnf install -y oracle-database-preinstall-23c

echo "******************************************************************************"
echo "Install Oracle RPM." `date`
echo "******************************************************************************"
dnf -y localinstall /vagrant/software/oracle-database-free-23c-1.0-1.el8.x86_64.rpm
#dnf update -y


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
