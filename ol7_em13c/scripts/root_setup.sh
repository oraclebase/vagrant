# Prepare the disk.
# New partition for the whole disk.
fdisk /dev/sdb <<EOF
n
p
1


w
EOF

# Add file system.
mkfs.xfs -f /dev/sdb1

# Mount it.
UUID=`blkid -o value /dev/sdb1 | grep -v xfs`
mkdir /u01
cat >> /etc/fstab <<EOF
UUID=${UUID}  /u01    xfs    defaults 1 2
EOF
mount /u01


# Prepare yum with the latest repos.
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget http://yum.oracle.com/public-yum-ol7.repo
yum -y install yum-utils zip unzip
yum -y install oracle-database-server-12cR2-preinstall
yum -y install make
yum -y install binutils
yum -y install gcc
yum -y install libaio
yum -y install glibc-common
yum -y install libstdc++
yum -y install libXtst
yum -y install sysstat
yum -y install glibc
yum -y install glibc-devel
yum -y install glibc-devel.i686

yum -y groupinstall "Server with GUI"
systemctl set-default graphical.target

#yum -y update

# Set up evironment for one-off actions.
export ORACLE_HOSTNAME=ol7-emcc.localdomain
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.2.0.1/db_1
export SOFTWARE_DIR=/u01/software
export ORA_INVENTORY=/u01/app/oraInventory
export SCRIPTS_DIR=/home/oracle/scripts
export DATA_DIR=/u01/oradata
export ORACLE_PASSWORD="oracle"

# Set the hostname.
cat >> /etc/hosts <<EOF
127.0.0.1  ${ORACLE_HOSTNAME}
EOF

cat > /etc/hostname <<EOF
${ORACLE_HOSTNAME}
EOF

hostname ${ORACLE_HOSTNAME}


mkdir -p ${SCRIPTS_DIR}
mkdir -p ${SOFTWARE_DIR}
mkdir -p ${DATA_DIR}
mkdir -p /u01/tmp
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01

# Set the oracle password.
echo "oracle:${ORACLE_PASSWORD}"|chpasswd

# Copy the "oracle_setup.sh" config file from the vagrant directory and run it.
cp -f /vagrant/scripts/* ${SOFTWARE_DIR}
cp -f /vagrant/software/* ${SOFTWARE_DIR}
chown -R oracle.oinstall ${SOFTWARE_DIR}
chmod +x ${SOFTWARE_DIR}/*.sh

# Prepare environment and install the software.
su - oracle -c '/u01/software/oracle_user_environment_setup.sh'
su - oracle -c '/u01/software/oracle_software_installation.sh'

# Run root scripts.
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

# Create the database and install the ORDS software.
su - oracle -c '/u01/software/oracle_create_database.sh'
