echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 192.168.56.1" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo
yum install -y yum-utils
yum-config-manager --enable ol7_developer_EPEL
yum install -y zip unzip
yum install -y oracle-database-preinstall-19c
yum install -y glibc zlib libaio
#yum -y update
