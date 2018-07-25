# This is an optional file used for my setup.

# Set up environment for demos.
echo "export JAVA_HOME=/home/docker_user/java/latest" >> ~/.bash_profile
echo "alias sql=\"/home/docker_user/sqlcl/bin/sql\"" >> ~/.bash_profile

cd ~
unzip -oq /vagrant/software/sqlcl-18.2.0.zip
mkdir ~/java
cd ~/java
tar -xf /vagrant/software/jdk-10.0.2_linux-x64_bin.tar.gz
ln -s ./j* ./latest
cd ~
unzip /vagrant/software/autorest_demo.zip

# Copy ORDS software and do build.
cd ~/dockerfiles/ords/ol7_ords/software
cp /vagrant/software/apex_18.1_en.zip .
cp /vagrant/software/apache-tomcat-9.0.10.tar.gz .
cp /vagrant/software/ords-18.2.0.zip .
cp /vagrant/software/sqlcl-18.2.0.zip .
cp /vagrant/software/jdk-10.0.2_linux-x64_bin.tar.gz .
cd ..
docker build -t ol7_ords:latest .

# Copy database software and do build.
cd ~/dockerfiles/database/ol7_183/software
cp /vagrant/software/LINUX.X64_180000_db_home.zip .
cp /vagrant/software/apex_18.1_en.zip .
cd ..
docker build -t ol7_183:latest .

# Start application.

cd ~/dockerfiles/compose/ol7_183_ords
docker-compose up
