echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf 
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

yum install -y libnsl bind sysstat unixODBC unixODBC-devel binutils dnsmasq  zip unzip 
curl -o sshpass-1.06-2.el7.x86_64.rpm     http://mirror.centos.org/centos/7/extras/x86_64/Packages/sshpass-1.06-2.el7.x86_64.rpm
yum -y localinstall sshpass-1.06-2.el7.x86_64.rpm
curl -o compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
curl -o compat-libcap1-1.10-7.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm 
yum -y localinstall compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm compat-libcap1-1.10-7.el7.x86_64.rpm
curl -o oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
yum -y localinstall oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
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
sed -i -e "s|SELINUX=enforcing|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive


echo "******************************************************************************"
echo "User setup." `date`
echo "******************************************************************************"
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper

useradd -u 54321 -g oinstall -G dba,oper oracle


echo "******************************************************************************"
echo "Fix for Oracle on OL8." `date`
echo "******************************************************************************"
rm -f /usr/lib64/libnsl.so.1
rm -f /usr/lib/libnsl.so.1
ln -s /usr/lib64/libnsl.so.2.0.0 /usr/lib64/libnsl.so.1
ln -s /usr/lib/libnsl.so.2.0.0 /usr/lib/libnsl.so.1
