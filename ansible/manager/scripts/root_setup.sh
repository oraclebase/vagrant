sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set up environment for one-off actions." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
147.188.56.100 ansible-manager
147.188.56.101  ansible-server1
147.188.56.102  ansible-server2
147.188.56.103  ansible-server3
EOF

cat >> /etc/ansible/hosts <<EOF
[my_servers]
server1
server2
server3
EOF


echo "******************************************************************************"
echo "Set up user equivalence." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
