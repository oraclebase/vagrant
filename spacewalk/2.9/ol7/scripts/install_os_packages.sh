echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

yum install -y yum-utils zip unzip
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_developer_EPEL
yum-config-manager --enable ol7_addons
rpm -Uvh https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9/epel-7-x86_64/00912457-spacewalk-repo/spacewalk-repo-2.9-4.el7.noarch.rpm



echo "******************************************************************************"
echo "Install Spacewalk package." `date`
echo "******************************************************************************"

yum install spacewalk-setup-postgresql -y
yum install spacewalk-postgresql -y

#yum update -y
