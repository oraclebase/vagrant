# Prepare yum.
#dnf groupinstall "GNOME Desktop" -y
dnf groupinstall "Development Tools" -y
dnf groupinstall "Administration Tools" -y
dnf groupinstall "System Tools" -y
dnf install firefox -y
dnf install binutils -y
dnf install compat-libcap1 -y
dnf install compat-libstdc++-33 -y
dnf install compat-libstdc++-33.i686 -y
dnf install glibc -y
dnf install glibc.i686 -y
dnf install glibc-devel -y
dnf install glibc-devel.i686 -y
dnf install ksh -y
dnf install libaio -y
dnf install libaio.i686 -y
dnf install libaio-devel -y
dnf install libaio-devel.i686 -y
dnf install libX11 -y
dnf install libX11.i686 -y
dnf install libXau -y
dnf install libXau.i686 -y
dnf install libXi -y
dnf install libXi.i686 -y
dnf install libXtst -y
dnf install libXtst.i686 -y
dnf install libgcc -y
dnf install libgcc.i686 -y
dnf install libstdc++ -y
dnf install libstdc++.i686 -y
dnf install libstdc++-devel -y
dnf install libstdc++-devel.i686 -y
dnf install libxcb -y
dnf install libxcb.i686 -y
dnf install make -y
dnf install nfs-utils -y
dnf install net-tools -y
dnf install smartmontools -y
dnf install sysstat -y
dnf install unixODBC -y
dnf install unixODBC-devel -y
dnf install elfutils-libelf-devel -y

#dnf update -y



# Kernel parameters.
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

/sbin/sysctl -p



# Limits
cat > /etc/security/limits.d/oracle-database-server-12cR2-preinstall.conf <<EOF
oracle   soft   nofile    1024
oracle   hard   nofile    65536
oracle   soft   nproc    16384
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32868
oracle   hard   memlock    134217728
oracle   soft   memlock    134217728
EOF


# Firewall
systemctl stop firewalld
systemctl disable firewalld


# SELinux
sed -i -e "s|SELINUX=enabled|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive



# User setup.
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper

useradd -u 54321 -g oinstall -G dba,oper oracle



# Setup paths.
mkdir -p /u01/app/oracle/product/12.2.0.1/db_1
chown -R oracle:oinstall /u01
chmod -R 775 /u01



# Fake OS.
cat > /etc/redhat-release <<EOF
redhat release 7
EOF



# Fix for Oracle on F28.
ln -s /usr/lib64/libnsl.so.2.0.0 /usr/lib64/libnsl.so.1
ln -s /usr/lib/libnsl.so.2.0.0 /usr/lib/libnsl.so.1



# Copy the "docker_user_setup.sh" config file from the vagrant directory and run it.
cp /vagrant/scripts/oracle_setup.sh /home/oracle/
chown oracle:oinstall /home/oracle/oracle_setup.sh
chmod +x /home/oracle/oracle_setup.sh
sudo su - oracle -c '/home/oracle/oracle_setup.sh'
