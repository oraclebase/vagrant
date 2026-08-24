echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y dnf-utils zip unzip

dnf install -y oracle-epel-release-el10
dnf install -y sshpass

dnf install -y oracle-ai-database-preinstall-26ai


echo "******************************************************************************"
echo "Add extra OS packages. Most should be present." `date`
echo "******************************************************************************"
dnf install -y bc
dnf install -y binutils
dnf install -y elfutils-libelf
dnf install -y fontconfig
dnf install -y glibc
dnf install -y glibc-devel
dnf install -y glibc-headers
dnf install -y ksh
dnf install -y libaio
dnf install -y libgcc
dnf install -y libibverbs
dnf install -y libnsl
dnf install -y libnsl2
dnf install -y libnsl2-devel
dnf install -y libstdc++
dnf install -y libvirt-libs
dnf install -y libxcb
dnf install -y libX11
dnf install -y libXau
dnf install -y libXi
dnf install -y libXrender
dnf install -y libXtst
dnf install -y libxcrypt-compat
dnf install -y make
dnf install -y policycoreutils
dnf install -y policycoreutils-python-utils
dnf install -y smartmontools
dnf install -y sysstat
dnf install -y ipmiutil 
dnf install -y net-tools
dnf install -y nfs-utils

# Added by me.
dnf install -y unixODBC


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


echo "******************************************************************************"
echo "Allow SSH login as root." `date`
echo "******************************************************************************"
rm -f /etc/ssh/sshd_config.d/01-permitrootlogin.conf
rm -f /etc/ssh/sshd_config.d/90-vagrant.conf
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/99-custom.conf
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/99-custom.conf
echo "UseDNS no" >> /etc/ssh/sshd_config.d/99-custom.conf
systemctl restart sshd
echo "+:oracle:${NODE1_PUBLIC_IP} ${NODE2_PUBLIC_IP} LOCAL" >> /etc/security/access.conf
echo "+:root:${NODE1_PUBLIC_IP} ${NODE2_PUBLIC_IP} LOCAL" >> /etc/security/access.conf
echo "+:dba:${NODE1_PUBLIC_IP} ${NODE2_PUBLIC_IP} LOCAL" >> /etc/security/access.conf

