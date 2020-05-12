. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/oracle/scripts

cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=${NODE2_FQ_HOSTNAME}
export ORACLE_UNQNAME=${ORACLE_UNQNAME}
export ORACLE_BASE=${ORACLE_BASE}
export ORA_INVENTORY=${ORA_INVENTORY}
export GRID_HOME=${GRID_HOME}
export DB_HOME=\$ORACLE_BASE/${DB_HOME_EXT}
export ORACLE_HOME=\$DB_HOME
export ORACLE_SID=${NODE2_ORACLE_SID}
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
export ORACLE_SID=+ASM2
export ORACLE_HOME=\$GRID_HOME
export PATH=\$ORACLE_HOME/bin:\$BASE_PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

cat > /home/oracle/scripts/db_env <<EOF
export ORACLE_SID=${NODE2_ORACLE_SID}
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
cat /dev/zero | ssh-keygen -t dsa -q -N "" > /dev/null
cat id_dsa.pub >> authorized_keys
ssh ${NODE2_HOSTNAME} date
echo "${ORACLE_PASSWORD}" > /tmp/temp2.txt
