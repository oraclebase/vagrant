echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum -y install yum-utils zip unzip
yum -y install oracle-database-server-12cR2-preinstall
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

yum -y groupinstall "Server with GUI"
systemctl set-default graphical.target

#yum -y update
