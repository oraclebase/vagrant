echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum -y install yum-utils zip unzip
yum -y install oracle-database-preinstall-18c
yum -y install make
yum -y install binutils
yum -y install gcc
yum -y install libaio
yum -y install glibc-common
yum -y install libstdc++
yum -y install libXtst
yum -y install sysstat
yum -y install glibc
yum -y install glibc-devel
yum -y install glibc-devel.i686

#yum -y groupinstall "Server with GUI"
#systemctl set-default graphical.target

#yum -y update
