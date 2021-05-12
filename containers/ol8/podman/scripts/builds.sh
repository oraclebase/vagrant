# This is an optional file used for my setup.

# Set up environment for demos.
echo "export JAVA_HOME=/home/container_user/java/latest" >> ~/.bash_profile
echo "alias sql=\"/home/container_user/sqlcl/bin/sql\"" >> ~/.bash_profile

cd ~
unzip -oq /vagrant/software/sqlcl-21.1.0.104.1544.zip
mkdir ~/java
cd ~/java
tar -xf /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
ln -s ./j* ./latest
cd ~
unzip -oq /vagrant/software/autorest_demo.zip

# Get latest oraclelinux:7-slim
podman pull oraclelinux:7-slim
podman pull oraclelinux:8-slim
podman pull oraclelinux:8

# Copy ORDS software and do build (OL7).
cd /u01/dockerfiles/ords/ol7_ords/software
cp /vagrant/software/apex_21.1_en.zip .
cp /vagrant/software/apache-tomcat-9.0.45.tar.gz .
cp /vagrant/software/ords-21.1.1.116.2032.zip .
cp /vagrant/software/sqlcl-21.1.0.104.1544.zip .
cp /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz .
cd /u01/dockerfiles/ords/ol7_ords
podman build --no-cache -t ol7_ords:latest .

# Copy ORDS software and do build (OL8).
cd /u01/dockerfiles/ords/ol8_ords/software
cp /vagrant/software/apex_21.1_en.zip .
cp /vagrant/software/apache-tomcat-9.0.45.tar.gz .
cp /vagrant/software/ords-21.1.1.116.2032.zip .
cp /vagrant/software/sqlcl-21.1.0.104.1544.zip .
cp /vagrant/software/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz .
cd /u01/dockerfiles/ords/ol8_ords
podman build --no-cache -t ol8_ords:latest .

# Copy database software and do build (OL7).
cd /u01/dockerfiles/database/ol7_19/software
cp /vagrant/software/LINUX.X64_193000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_19
podman build --no-cache -t ol7_19:latest .

# Copy database software and do build (OL8).
cd /u01/dockerfiles/database/ol8_19/software
cp /vagrant/software/LINUX.X64_193000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cp /vagrant/software/p6880880_190000_Linux-x86-64.zip .
cp /vagrant/software/p32578972_190000_Linux-x86-64.zip .
cd /u01/dockerfiles/database/ol8_19
podman build --no-cache -t ol8_19:latest .

# Copy database software and do build (OL7).
cd /u01/dockerfiles/database/ol7_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_183
#podman build --no-cache -t ol7_183:latest .

# Copy database software and do build (OL8).
cd /u01/dockerfiles/database/ol8_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol8_183
#podman build --no-cache -t ol8_183:latest .

# Copy database software and don't do build.
cd /u01/dockerfiles/database/ol7_122/software
cp /vagrant/software/linuxx64_12201_database.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_122
#podman build --no-cache -t ol7_122:latest .

# Copy database software and don't do build.
cd /u01/dockerfiles/database/ol7_121/software
cp /vagrant/software/linuxamd64_12102_database_*of2.zip .
cp /vagrant/software/apex_21.1_en.zip .
cd /u01/dockerfiles/database/ol7_121
#podman build --no-cache -t ol7_121:latest .

# Setup file system to allow container_user to interact
# with podman host volumes.

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
groupadd -g 1042 container_fg
chown -R :container_fg /u01
chmod -R 775 /u01/volumes
chmod -R g+s /u01/volumes
usermod -aG container_fg container_user

# Run an application.
podman pod create --name my_pod --publish=1521:1521 --publish=5500:5500 --publish=8080:8080 --publish=8443:8443
podman pod ls

podman run -dit \
           --name=ol8_19_con \
           --pod=my_pod \
           --volume=/u01/volumes/ol8_19_ords_db/:/u02 \
           ol8_19:latest
podman logs --follow ol8_19_con

podman run -dit \
           --name ol8_ords_con \
           --pod=my_pod \
           -e="DB_HOSTNAME=ol8_19_con" \
           -v=/u01/volumes/ol8_19_ords_tomcat:/u01/config/instance1 \
           ol8_ords:latest
podman logs --follow ol8_ords_con

~/sqlcl/bin/sql sys/SysPassword1@//localhost:1521/pdb1 as sysdba

podman pod stop my_pod

podman rm -vf ol8_ords_con
podman rm -vf ol8_19_con
podman pod rm my_pod

podman ps -a
podman pod rm --all



# Run an application.
podman pod create --name my_pod --publish=1521 --publish=5500 --publish=8080 --publish=8443
podman pod ls

podman run -dit \
           --name=ol7_19_con \
           --pod=my_pod \
           --volume=/u01/volumes/ol7_19_ords_db/:/u02 \
           ol7_19:latest
podman logs --follow ol7_19_con

podman run -dit \
           --name ol7_ords_con \
           --pod=my_pod \
           -e="DB_HOSTNAME=localhost" \
           -v=/u01/volumes/ol7_19_ords_tomcat:/u01/config/instance1 \
           ol7_ords:latest
podman logs --follow ol7_ords_con

~/sqlcl/bin/sql sys/SysPassword1@//localhost:1521/pdb1 as sysdba

podman pod stop my_pod

podman rm -vf ol7_ords_con
podman rm -vf ol7_19_con
podman pod rm my_pod

podman ps -a
podman pod rm --all


