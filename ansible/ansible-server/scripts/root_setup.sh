sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Edit hosts and ansible hosts." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
192.168.56.100 ansible-server.localdomain ansible-server
192.168.56.101 appserver1.localdomain appserver1
192.168.56.102 appserver2.localdomain appserver2
192.168.56.103 database1.localdomain database1
EOF

cat >> /etc/ansible/hosts <<EOF
ansible-server.localdomain

[appservers]
appserver1.localdomain
appserver2.localdomain

[databases]
database1.localdomain
EOF

echo "******************************************************************************"
echo "Check ansible version." `date`
echo "******************************************************************************"
ansible --version
