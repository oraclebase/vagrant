echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

yum install -y yum-utils zip unzip

echo "******************************************************************************"
echo "Install Oracle prerequisite package." `date`
echo "Not necessary, but oracle OS user has no home directory if this is not run first."
echo "******************************************************************************"
yum install -y oracle-database-preinstall-18c

echo "******************************************************************************"
echo "Install Oracle RPM." `date`
echo "******************************************************************************"
yum -y localinstall /vagrant/software/oracle-database-xe-18c-1.0-1.x86_64.rpm
#yum update -y

echo "******************************************************************************"
echo "Create the database by running this script as root," `date`
echo "giving a password when prompted." `date`
echo "******************************************************************************"
echo "/etc/init.d/oracle-xe-18c configure"