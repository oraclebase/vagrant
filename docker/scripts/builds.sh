# This is an optional file used for my setup.

# Set up environment for demos.
echo "export JAVA_HOME=/home/docker_user/java/latest" >> ~/.bash_profile
echo "alias sql=\"/home/docker_user/sqlcl/bin/sql\"" >> ~/.bash_profile

cd ~
unzip -oq /vagrant/software/sqlcl-18.4.0.007.1818.zip
mkdir ~/java
cd ~/java
tar -xf /vagrant/software/openjdk-11.0.2_linux-x64_bin.tar.gz
ln -s ./j* ./latest
cd ~
unzip -oq /vagrant/software/autorest_demo.zip

# Copy ORDS software and do build.
cd ~/dockerfiles/ords/ol7_ords/software
cp /vagrant/software/apex_18.2_en.zip .
cp /vagrant/software/apache-tomcat-9.0.14.tar.gz .
cp /vagrant/software/ords-18.4.0.354.1002.zip .
cp /vagrant/software/sqlcl-18.4.0.007.1818.zip .
cp /vagrant/software/openjdk-11.0.2_linux-x64_bin.tar.gz .
cd ~/dockerfiles/ords/ol7_ords
docker build --squash -t ol7_ords:latest .

# Copy database software and do build.
cd ~/dockerfiles/database/ol7_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_18.2_en.zip .
cd ~/dockerfiles/database/ol7_183
docker build --squash -t ol7_183:latest .

# Copy database software and don't do build.
cd ~/dockerfiles/database/ol7_122/software
cp /vagrant/software/linuxx64_12201_database.zip .
cp /vagrant/software/apex_18.2_en.zip .
cd ~/dockerfiles/database/ol7_122
#docker build --squash -t ol7_122:latest .

# Setup file system to allow docker_user to interact
# with docker host volumes.

# This setup is now in the root_setup.sh
mkdir -p /home/docker_user/volumes/ol7_183_ords_tomcat
mkdir -p /home/docker_user/volumes/ol7_183_ords_db
# As root user.
groupadd -g 1042 docker_fg
chown -R :docker_fg /home/docker_user/volumes
chmod -R 775 /home/docker_user/volumes
chmod -R g+s /home/docker_user/volumes
usermod -aG docker_fg docker_user

# Start application.

# Compose
cd ~/dockerfiles/compose/ol7_183_ords
docker-compose rm -vfs
docker-compose up

#cd ~/dockerfiles/compose/ol7_122_ords
#docker-compose up


# Swarm
docker swarm init
cd ~/dockerfiles/swarm/ol7_183_ords
docker stack deploy --compose-file ./docker-stack.yml ords-stack

docker stack ls
docker service ls
docker stack ps ords-stack
docker ps -a

docker service scale ords-stack_ords=5
docker stack ps ords-stack

docker service scale ords-stack_ords=2
docker stack ps ords-stack

docker stack rm ords-stack
docker stack ps ords-stack

docker swarm leave -f
