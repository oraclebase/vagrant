echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
cd /etc/yum.repos.d
#rm -f public-yum-ol6.repo
#wget http://yum.oracle.com/public-yum-ol6.repo
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum install -y yum-utils
yum-config-manager --enable ol7_developer_EPEL
yum install -y zip unzip # sshpass 
yum install -y oracle-database-preinstall-18c
#yum -y update
