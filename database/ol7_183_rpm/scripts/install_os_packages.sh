echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum install -y yum-utils zip unzip

echo "******************************************************************************"
echo "Install Oracle prerequisite package." `date`
echo "Not necessary, but oracle OS user has no home directory if this is not run first."
echo "******************************************************************************"
yum install -y oracle-database-preinstall-18c

echo "******************************************************************************"
echo "Install Oracle RPM." `date`
echo "******************************************************************************"
yum -y localinstall /vagrant/software/oracle-database-ee-18c-1.0-1.x86_64.rpm
#yum update -y
