sh /vagrant/scripts/prepare_disks.sh

echo "******************************************************************************"
echo "Prepare dnf with the latest repos." `date`
echo "******************************************************************************"
dnf install -y dnf-utils zip unzip

#dnf groupinstall "GNOME Desktop" -y
#dnf groupinstall "Development Tools" -y
#dnf groupinstall "Administration Tools" -y
#dnf groupinstall "System Tools" -y
dnf install -y bc    
dnf install -y binutils
#dnf install -y compat-libcap1
dnf install -y compat-libstdc++-33
dnf install -y compat-libstdc++-33.i686
dnf install -y elfutils-libelf.i686
dnf install -y elfutils-libelf
dnf install -y elfutils-libelf-devel.i686
dnf install -y elfutils-libelf-devel
dnf install -y fontconfig-devel
dnf install -y glibc.i686
dnf install -y glibc
dnf install -y glibc-devel.i686
dnf install -y glibc-devel
dnf install -y ksh
dnf install -y libaio.i686
dnf install -y libaio
dnf install -y libaio-devel.i686
dnf install -y libaio-devel
dnf install -y libX11.i686
dnf install -y libX11
dnf install -y libXau.i686
dnf install -y libXau
dnf install -y libXi.i686
dnf install -y libXi
dnf install -y libXtst.i686
dnf install -y libXtst
dnf install -y libgcc.i686
dnf install -y libgcc
dnf install -y librdmacm-devel
dnf install -y libstdc++.i686
dnf install -y libstdc++
dnf install -y libstdc++-devel.i686
dnf install -y libstdc++-devel
dnf install -y libxcb.i686
dnf install -y libxcb
dnf install -y make
dnf install -y nfs-utils
dnf install -y net-tools
dnf install -y python
dnf install -y python-configshell
dnf install -y python-rtslib
dnf install -y python-six
dnf install -y smartmontools
dnf install -y sysstat
dnf install -y targetcli
dnf install -y unixODBC

# New for F30
dnf install -y libnsl2
dnf install -y libnsl2.i686
dnf install -y libxcrypt-compat
dnf install -y http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/c/compat-libpthread-nonshared-2.29.9000-31.fc31.x86_64.rpm

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
cat > /etc/security/limits.d/oracle-database-server-18c-preinstall.conf <<EOF
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
echo "Fake OS." `date`
echo "******************************************************************************"
cat > /etc/redhat-release <<EOF
redhat release 7
EOF


echo "******************************************************************************"
echo "Fix for Oracle on F28." `date`
echo "******************************************************************************"
rm -f /usr/lib64/libnsl.so.1
rm -f /usr/lib/libnsl.so.1
ln -s /usr/lib64/libnsl.so.2.0.0 /usr/lib64/libnsl.so.1
ln -s /usr/lib/libnsl.so.2.0.0 /usr/lib/libnsl.so.1


echo "******************************************************************************"
echo "Set up evironment for one-off actions." `date`
echo "******************************************************************************" 
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/18.0.0/dbhome_1
export SOFTWARE_DIR=/u01/software
export ORA_INVENTORY=/u01/app/oraInventory
export SCRIPTS_DIR=/home/oracle/scripts
export DATA_DIR=/u02/oradata

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01 /u02


echo "******************************************************************************"
echo "Copy software and scripts from the vagrant directory." `date`
echo "******************************************************************************" 
cp -f /vagrant/scripts/* ${SOFTWARE_DIR}
cp -f /vagrant/software/* ${SOFTWARE_DIR}
chown -R oracle.oinstall ${SOFTWARE_DIR}
chmod +x ${SOFTWARE_DIR}/*.sh


echo "******************************************************************************"
echo "Prepare environment and install the software." `date`
echo "******************************************************************************" 
su - oracle -c '/u01/software/oracle_user_environment_setup.sh'
su - oracle -c '/u01/software/oracle_software_installation.sh'


echo "******************************************************************************"
echo "Run root scripts." `date`
echo "******************************************************************************" 
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh


echo "******************************************************************************"
echo "Create the database." `date`
echo "******************************************************************************" 
su - oracle -c '/u01/software/oracle_create_database.sh'
