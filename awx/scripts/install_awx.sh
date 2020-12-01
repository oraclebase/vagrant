echo "******************************************************************************"
echo "Install AWX" `date`
echo "******************************************************************************"
pip3 install --upgrade pip
pip3 install docker
pip3 install docker-compose

cd /u01/
git clone https://github.com/ansible/awx.git
cd awx/installer

# For a real installation, you will probably need to change many of these.
sed -i -e "s|awx_task_hostname=awx|awx_task_hostname=${AWX_TASK_HOSTNAME}|g" ./inventory
sed -i -e "s|awx_web_hostname=awxweb|awx_web_hostname=${AWX_WEB_HOSTNAME}|g" ./inventory

sed -i -e "s|postgres_data_dir=\"~/.awx/pgdocker\"|postgres_data_dir=${POSTGRES_DATA_DIR}|g" ./inventory

# Don't change, unless you are changing the Vagrant port forwarding.
sed -i -e "s|host_port=80|host_port=${HOST_PORT}|g" ./inventory
sed -i -e "s|host_port_ssl=443|host_port_ssl=${HOST_PORT_SSL}|g" ./inventory

sed -i -e "s|docker_compose_dir=\"~/.awx/awxcompose\"|docker_compose_dir=${DOCKER_COMPOSE_DIR}|g" ./inventory

sed -i -e "s|pg_username=awx|pg_username=${PG_USERNAME}|g" ./inventory
sed -i -e "s|pg_password=awxpass|pg_password=${PG_PASSWORD}|g" ./inventory
sed -i -e "s|pg_database=awx|pg_database=${PG_DATABASE}|g" ./inventory
sed -i -e "s|pg_port=5432|pg_port=${PG_PORT}|g" ./inventory

sed -i -e "s|rabbitmq_password=awxpass|rabbitmq_password=${RABBITMQ_PASSWORD}|g" ./inventory

sed -i -e "s|admin_user=admin|admin_user=${ADMIN_USER}|g" ./inventory
sed -i -e "s|admin_password=password|admin_password=${ADMIN_PASSWORD}|g" ./inventory

sed -i -e "s|secret_key=awxsecret|secret_key=${SECRET_KEY}|g" ./inventory

sed -i -e "s|#project_data_dir=/var/lib/awx/projects|project_data_dir=${PROJECT_DATA_DIR}|g" ./inventory

ansible-playbook -i inventory install.yml
