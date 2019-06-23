echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo
yum install -y yum-utils zip unzip
yum install -y oracle-rdbms-server-12cR1-preinstall
yum install -y make
yum install -y binutils
yum install -y gcc
yum install -y libaio
yum install -y glibc-common
yum install -y libstdc++
yum install -y libXtst
yum install -y sysstat
yum install -y glibc
yum install -y glibc-devel
yum install -y glibc-devel.i686

#yum -y groupinstall "Server with GUI"
#systemctl set-default graphical.target

#yum -y update
