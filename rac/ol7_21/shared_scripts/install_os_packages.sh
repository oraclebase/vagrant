echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum install -y yum-utils
yum install -y oracle-epel-release-el7
yum-config-manager --enable ol7_developer_EPEL
yum install -y sshpass zip unzip
yum install -y oracle-database-preinstall-21c

echo "******************************************************************************"
echo "Add extra OS packages. Most should be present." `date`
echo "******************************************************************************"
yum install -y bc
yum install -y binutils
yum install -y elfutils-libelf
yum install -y glibc
yum install -y glibc-devel
yum install -y ksh
yum install -y libaio
yum install -y libXrender
yum install -y libX11
yum install -y libXau
yum install -y libXi
yum install -y libXtst
yum install -y libgcc
yum install -y libstdc++
yum install -y libxcb
yum install -y make
yum install -y policycoreutils
yum install -y policycoreutils-python
yum install -y smartmontools
yum install -y sysstat
yum install -y net-tools
yum install -y nfs-utils

# Added by me.
yum install -y unixODBC


echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld


echo "******************************************************************************"
echo "SELinux." `date`
echo "******************************************************************************"
sed -i -e "s|SELINUX=enforcing|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive
