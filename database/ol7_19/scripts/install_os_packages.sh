echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

yum install -y yum-utils zip unzip
yum install -y oracle-database-preinstall-19c

# Configure rlwrap for SQL*PLus command history.
yum-config-manager --enable ol7_developer_EPEL
yum install -y rlwrap

cat >> /home/oracle/.bash_profile <<EOF
alias sqlplus='rlwrap sqlplus'
alias rman='rlwrap rman'
EOF

#yum update -y
#yum groupinstall -y "Server with GUI"
#systemctl set-default graphical.target
