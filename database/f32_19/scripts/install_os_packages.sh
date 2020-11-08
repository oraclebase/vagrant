echo "******************************************************************************"
echo "Install OS Packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y dnf-utils zip unzip

#dnf groupinstall "GNOME Desktop" -y
#dnf groupinstall "Development Tools" -y
#dnf groupinstall "Administration Tools" -y
#dnf groupinstall "System Tools" -y
dnf install -y bc    
dnf install -y binutils
#dnf install -y compat-libcap1
dnf install -y compat-libstdc++-33
#dnf install -y dtrace-modules
#dnf install -y dtrace-modules-headers
#dnf install -y dtrace-modules-provider-headers
#dnf install -y dtrace-utils
dnf install -y elfutils-libelf
dnf install -y elfutils-libelf-devel
dnf install -y fontconfig-devel
dnf install -y glibc
dnf install -y glibc-devel
dnf install -y ksh
dnf install -y libaio
dnf install -y libaio-devel
#dnf install -y libdtrace-ctf-devel
dnf install -y libXrender
dnf install -y libXrender-devel
dnf install -y libX11
dnf install -y libXau
dnf install -y libXi
dnf install -y libXtst
dnf install -y libgcc
dnf install -y librdmacm-devel
dnf install -y libstdc++
dnf install -y libstdc++-devel
dnf install -y libxcb
dnf install -y make
dnf install -y net-tools # Clusterware
dnf install -y nfs-utils # ACFS
dnf install -y python # ACFS
dnf install -y python-configshell # ACFS
dnf install -y python-rtslib # ACFS
dnf install -y python-six # ACFS
dnf install -y targetcli # ACFS
dnf install -y smartmontools
dnf install -y sysstat

# Added by me.
dnf install -y unixODBC

# New for F32
dnf install -y libnsl2
dnf install -y libnsl2.i686
dnf install -y libxcrypt-compat
dnf install -y http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/c/compat-libpthread-nonshared-2.32.9000-14.fc34.x86_64.rpm

#dnf update -y


echo "******************************************************************************"
echo "Kernel parameters." `date`
echo "******************************************************************************"
cat > /etc/sysctl.d/98-oracle.conf <<EOF
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
EOF

/sbin/sysctl -p /etc/sysctl.d/98-oracle.conf


echo "******************************************************************************"
echo "Limits." `date`
echo "******************************************************************************"
cat > /etc/security/limits.d/oracle-database-server-19c-preinstall.conf <<EOF
oracle   soft   nofile    1024
oracle   hard   nofile    65536
oracle   soft   nproc    16384
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32868
oracle   hard   memlock    134217728
oracle   soft   memlock    134217728
EOF


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


echo "******************************************************************************"
echo "User setup." `date`
echo "******************************************************************************"
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper

useradd -u 54321 -g oinstall -G dba,oper oracle


echo "******************************************************************************"
echo "Fix for Oracle on F32." `date`
echo "******************************************************************************"
rm -f /usr/lib64/libnsl.so.1
rm -f /usr/lib/libnsl.so.1
ln -s /usr/lib64/libnsl.so.2.0.0 /usr/lib64/libnsl.so.1
ln -s /usr/lib/libnsl.so.2.0.0 /usr/lib/libnsl.so.1
