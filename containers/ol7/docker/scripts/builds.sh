# This is an optional file used for my setup.

# Set up environment for demos.
echo "export JAVA_HOME=/home/docker_user/java/latest" >> ~/.bash_profile
echo "alias sql=\"/home/docker_user/sqlcl/bin/sql\"" >> ~/.bash_profile

cd ~
unzip -oq /vagrant/software/sqlcl-21.1.0.104.1544.zip
mkdir ~/java
cd ~/java
tar -xf /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
ln -s ./j* ./latest
cd ~
unzip -oq /vagrant/software/autorest_demo.zip

# Get latest oraclelinux:7-slim
docker pull oraclelinux:7-slim
docker pull oraclelinux:8-slim

# Copy ORDS software and do build (OL7).
cd /u01/dockerfiles/ords/ol7_ords/software
cp /vagrant/software/apex_21.1_en.zip .
cp /vagrant/software/apache-tomcat-9.0.45.tar.gz .
cp /vagrant/software/ords-21.1.1.116.2032.zip .
cp /vagrant/software/sqlcl-21.1.0.104.1544.zip .
cp /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz .
cd /u01/dockerfiles/ords/ol7_ords
docker build --no-cache -t ol7_ords:latest .

# Copy ORDS software and do build (OL8).
cd /u01/dockerfiles/ords/ol8_ords/software
cp /vagrant/software/apex_21.1_en.zip .
cp /vagrant/software/apache-tomcat-9.0.45.tar.gz .
cp /vagrant/software/ords-21.1.1.116.2032.zip .
cp /vagrant/software/sqlcl-21.1.0.104.1544.zip .
cp /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz .
cd /u01/dockerfiles/ords/ol8_ords
docker build --no-cache -t ol8_ords:latest .

# Copy database software and do build (OL7).
cd /u01/dockerfiles/database/ol7_19/software
cp /vagrant/software/LINUX.X64_193000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_19
docker build --no-cache -t ol7_19:latest .

# Copy database software and do build (OL8).
cd /u01/dockerfiles/database/ol8_19/software
cp /vagrant/software/LINUX.X64_193000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol8_19
docker build --no-cache -t ol8_19:latest .

# Copy database software and do build (OL7).
cd /u01/dockerfiles/database/ol7_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_183
#docker build --no-cache -t ol7_183:latest .

# Copy database software and do build (OL8).
cd /u01/dockerfiles/database/ol8_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol8_183
#docker build --no-cache -t ol8_183:latest .

# Copy database software and don't do build.
cd /u01/dockerfiles/database/ol7_122/software
cp /vagrant/software/linuxx64_12201_database.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_122
#docker build --no-cache -t ol7_122:latest .

# Copy database software and don't do build.
cd /u01/dockerfiles/database/ol7_121/software
cp /vagrant/software/linuxamd64_12102_database_*of2.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_121
#docker build --no-cache -t ol7_121:latest .

# Setup file system to allow docker_user to interact
# with docker host volumes.

# This setup is now in the root_setup.sh
mkdir -p /u01/volumes/ol7_19_ords_tomcat
mkdir -p /u01/volumes/ol7_19_ords_db
mkdir -p /u01/volumes/ol7_183_ords_tomcat
mkdir -p /u01/volumes/ol7_183_ords_db
mkdir -p /u01/volumes/ol8_19_ords_tomcat
mkdir -p /u01/volumes/ol8_19_ords_db
mkdir -p /u01/volumes/ol8_183_ords_tomcat
mkdir -p /u01/volumes/ol8_183_ords_db
# As root user.
groupadd -g 1042 docker_fg
chown -R :docker_fg /u01
chmod -R 775 /u01/volumes
chmod -R g+s /u01/volumes
usermod -aG docker_fg docker_user

# Start application.

# Compose
cd /u01/dockerfiles/compose/ol7_19_ords
docker-compose rm -vfs
docker-compose up

cd /u01/dockerfiles/compose/ol8_19_ords
docker-compose rm -vfs
docker-compose up

#cd /u01/dockerfiles/compose/ol7_183_ords
#docker-compose rm -vfs
#docker-compose up

#cd /u01/dockerfiles/compose/ol8_183_ords
#docker-compose rm -vfs
#docker-compose up

#cd /u01/dockerfiles/compose/ol7_122_ords
#docker-compose up


# Swarm
docker swarm init
cd /u01/dockerfiles/swarm/ol7_19_ords
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
