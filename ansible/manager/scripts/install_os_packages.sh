echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum install yum-utils zip unzip -y
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_preview
yum-config-manager --enable ol7_developer
yum-config-manager --enable ol7_developer_EPEL

cat > ansible.repo <<EOF
[Ansible]
name=Ansible releases repo
baseurl=https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/
gpgkey=http://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub
gpgcheck=1
enabled=1
EOF

# Install ansible.
yum install -y ansible
