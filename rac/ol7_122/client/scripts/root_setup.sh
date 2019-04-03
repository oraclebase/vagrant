. /vagrant_config/install.env

echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

cat > /etc/resolv.conf <<EOF
search localdomain
nameserver ${DNS_PUBLIC_IP}
EOF

HOSTNAME=ol7-122-client
hostname ${HOSTNAME}
cat > /etc/hostname <<EOF
${HOSTNAME}
EOF

echo "PATH=\${PATH}:/usr/lib/oracle/12.2/client64/bin" >> /home/vagrant/.bashrc

yum install bind-utils -y
yum install /vagrant/oracle-instantclient12.2-*-12.2.0.1.0-1.x86_64.rpm -y

echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient12.2.conf && ldconfig

mkdir -p /home/vagrant/network/admin

cp /vagrant/tnsnames.ora /home/vagrant/network/admin

chown -R vagrant:vagrant /home/vagrant/network

echo "export TNS_ADMIN=~/network/admin" >> /home/vagrant/.bashrc