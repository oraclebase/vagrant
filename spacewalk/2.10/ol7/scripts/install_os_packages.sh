echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

yum install -y oracle-epel-release-el7
yum install -y yum-utils zip unzip

yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_developer_EPEL
yum-config-manager --enable ol7_addons

echo "******************************************************************************"
echo "Install Spacewalk package." `date`
echo "******************************************************************************"

yum install -y yum-plugin-tmprepo
yum install -y spacewalk-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10/epel-7-x86_64/repodata/repomd.xml --nogpg
yum install -y spacewalk-setup-postgresql
yum install -y spacewalk-postgresql

#yum update -y
