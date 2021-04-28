echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum install -y oracle-database-preinstall-19c

yum install -y binutils
yum install -y gcc
yum install -y gcc-c++
yum install -y glibc
yum install -y glibc-devel
yum install -y glibc-devel.i686
yum install -y libaio
yum install -y libaio-devel
yum install -y libgcc
yum install -y libstdc++
yum install -y libstdc++-devel
yum install -y libnsl
yum install -y sysstat
yum install -y motif
yum install -y motif-devel
yum install -y redhat-lsb
yum install -y redhat-lsb-core
yum install -y openssl
yum install -y make

# OL7 Packages
yum install -y libgcc.i686
yum install -y libstdc++.i686
yum install -y compat-libcap1
yum install -y compat-libstdc++-33
yum install -y compat-libstdc++-33.i686
yum install -y dejavu-serif-fonts
yum install -y ksh
yum install -y numactl
yum install -y numactl-devel

#yum -y groupinstall "Server with GUI"
#systemctl set-default graphical.target

#yum -y update
