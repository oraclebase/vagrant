echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
cd /etc/yum.repos.d
#rm -f public-yum-ol6.repo
#wget http://yum.oracle.com/public-yum-ol6.repo
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum -y install yum-utils zip unzip
yum -y install oracle-database-preinstall-18c
#yum -y update
