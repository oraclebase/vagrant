echo "******************************************************************************"
echo "Install OS Packages." `date`
echo "******************************************************************************"
dnf install -y curl
dnf install -y oracle-epel-release-el9.x86_64
dnf install -y python3.11
dnf install -y pip

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
