. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/oracle/scripts

cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=${NODE1_HOSTNAME}
export ORACLE_UNQNAME=${ORACLE_UNQNAME}
export ORACLE_BASE=${ORACLE_BASE}
export ORA_INVENTORY=${ORA_INVENTORY}
export GRID_HOME=${GRID_HOME}
export DB_HOME=\$ORACLE_BASE/${DB_HOME_EXT}
export ORACLE_HOME=\$DB_HOME
export ORACLE_SID=${NODE1_ORACLE_SID}
export ORACLE_TERM=xterm
export BASE_PATH=/usr/sbin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$BASE_PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

alias grid_env='. /home/oracle/scripts/grid_env'
alias db_env='. /home/oracle/scripts/db_env'
EOF

cat >> /home/oracle/.bash_profile <<EOF
. /home/oracle/scripts/setEnv.sh
EOF

cat > /home/oracle/scripts/grid_env <<EOF
export ORACLE_SID=+ASM1
export ORACLE_HOME=\$GRID_HOME
export PATH=\$ORACLE_HOME/bin:\$BASE_PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

cat > /home/oracle/scripts/db_env <<EOF
export ORACLE_SID=${NODE1_ORACLE_SID}
export ORACLE_HOME=\$DB_HOME
export PATH=\$ORACLE_HOME/bin:\$BASE_PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

echo "******************************************************************************"
echo "Create directories." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh
mkdir -p ${GRID_HOME}
mkdir -p ${DB_HOME}

echo "******************************************************************************"
echo "Passwordless SSH Setup for oracle." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE1_HOSTNAME} date
echo "${ORACLE_PASSWORD}" > /tmp/temp2.txt

ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
sshpass -f /tmp/temp2.txt ssh-copy-id ${NODE2_HOSTNAME}

cat > /tmp/ssh-setup.sh <<EOF
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
sshpass -f /tmp/temp2.txt ssh-copy-id ${NODE1_HOSTNAME}
EOF

ssh ${NODE2_HOSTNAME} 'bash -s' < /tmp/ssh-setup.sh

echo "******************************************************************************"
echo "Unzip grid software." `date`
echo "******************************************************************************"
cd ${GRID_HOME}
unzip -oq /vagrant_software/${GRID_SOFTWARE}
unzip -oq /vagrant_software/${OPATCH_FILE}
cd ${SOFTWARE_DIR}
unzip -oq /vagrant_software/${PATCH_FILE}

scp ${GRID_HOME}/cv/rpm/cvuqdisk-1.0.10-1.rpm oracle@${NODE2_HOSTNAME}:/tmp

# Optional cluster verification.
#${GRID_HOME}/runcluvfy.sh stage -pre crsinst -n "${NODE1_HOSTNAME},${NODE2_HOSTNAME}"
