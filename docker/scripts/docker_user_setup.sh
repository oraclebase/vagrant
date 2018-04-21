# Clone the latest Git repository. Use SSH so no password.
git clone https://github.com/oraclebase/dockerfiles.git

echo "*******************************************************"
echo "*** You need to copy all the software in place now! ***"
echo "*******************************************************"

cat <<EOF
cd ~/dockerfiles/database/ol7_122/software
cp /vagrant/software/linuxx64_12201_database.zip .
cp /vagrant/software/apex_5.1.4_en.zip .
cd ..
docker build -t ol7_122:latest .

cd ~/dockerfiles/ords/ol7_ords/software
cp /vagrant/software/apex_5.1.4_en.zip .
cp /vagrant/software/apache-tomcat-9.0.7.tar.gz .
cp /vagrant/software/ords.18.1.1.95.1251.zip .
cp /vagrant/software/sqlcl-18.1.0.zip .
cp /vagrant/software/jdk-10.0.1_linux-x64_bin.tar.gz .
cd ..
docker build -t ol7_ords:latest .
EOF
