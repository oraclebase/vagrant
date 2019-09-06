echo "******************************************************************************"
echo "Install AWX" `date`
echo "******************************************************************************"
pip install docker
pip install docker-compose

cd /u01/
git clone https://github.com/ansible/awx.git
cd awx/installer

# For a real installation, you will probably need to change all of these.
sed -i -e "s|awx_task_hostname=awx|awx_task_hostname=localhost|g" ./inventory
sed -i -e "s|awx_web_hostname=awxweb|awx_web_hostname=localhost|g" ./inventory

# Don't change, unless you are changing the Vagrant port forwarding.
#sed -i -e "s|host_port=80|host_port=80|g" ./inventory
#sed -i -e "s|host_port_ssl=443|host_port_ssl=443|g" ./inventory

#sed -i -e "s|pg_username=awx|pg_username=awxg" ./inventory
#sed -i -e "s|pg_password=awxpass|pg_password=awxpass|g" ./inventory
#sed -i -e "s|pg_database=awx|pg_database=awx|g" ./inventory
#sed -i -e "s|pg_port=5432|pg_port=5432|g" ./inventory

#sed -i -e "s|admin_user=admin|admin_user=admin|g" ./inventory
#sed -i -e "s|admin_password=password|admin_password=password|g" ./inventory

#sed -i -e "s|secret_key=awxsecret|secret_key=awxsecret|g" ./inventory

#sed -i -e "s|admin_password=password|admin_password=password|g" ./inventory
#sed -i -e "s|secret_key=awxsecret|secret_key=awxsecret|g" ./inventory

ansible-playbook -i inventory install.yml
