. /vagrant/config/install.env

echo "******************************************************************************"
echo "Update OMSPatcher." `date`
echo "******************************************************************************"
# OMSPatcher - May be new version of patch 19999993 each patch cycle.
export ORACLE_HOME=/u01/app/oracle/middleware
cd ${ORACLE_HOME}
mv OMSPatcher OMSPatcher-old
unzip -oq /vagrant/software/p19999993_135000_Generic.zip
$ORACLE_HOME/OMSPatcher/omspatcher version

echo "******************************************************************************"
echo "Update OPatch." `date`
echo "******************************************************************************"
sh /home/oracle/scripts/stop_cloud_control.sh

export ORACLE_HOME=/u01/app/oracle/middleware
export PATH=$ORACLE_HOME/OMSPatcher:$PATH
export JAVA_HOME=/u01/app/oracle/middleware/oracle_common/jdk

# OPatch - May be new version each patch cycle.
cd /u01/software/
unzip -oq /vagrant/software/p28186730_1394215_Generic.zip
$JAVA_HOME/bin/java -jar ./6880880/opatch_generic.jar -silent oracle_home=$ORACLE_HOME
export PATH=$ORACLE_HOME/OPatch:$PATH

echo "******************************************************************************"
echo "Prerequisite patches." `date`
echo "******************************************************************************"
cd /u01/software
unzip -oq /vagrant/software/p32720458_122140_Generic.zip
cd 32720458
opatch apply -silent

cd /u01/software
unzip -oq /vagrant/software/p35430934_122140_Generic.zip
cd 35430934
opatch apply -silent

cd /u01/software
unzip -oq /vagrant/software/p31657681_191000_Generic.zip
cd 31657681
opatch apply -silent

cd /u01/software
unzip -oq /vagrant/software/p34153238_122140_Generic.zip
cd 34153238
opatch apply -silent

sh /home/oracle/scripts/start_cloud_control.sh

echo "******************************************************************************"
echo "OMS Base Home - Analyze." `date`
echo "******************************************************************************"
mkdir -p /tmp/keys

${ORACLE_HOME}/OMSPatcher/wlskeys/createkeys.sh –oh ${ORACLE_HOME} -location /tmp/keys <<EOF
${WLS_USERNAME}
${WLS_PASSWORD}
EOF

cat > /tmp/property_file.txt <<EOF
AdminServerURL=t3s://${HOSTNAME}:7102
AdminConfigFile=/tmp/keys/config
AdminKeyFile=/tmp/keys/key
Sys_pwd=${SYS_PASSWORD}
EOF

export ORACLE_HOME=/u01/app/oracle/middleware
cd /u01/software
unzip -oq /vagrant/software/p36335368_135000_Generic.zip
cd 36335368
omspatcher apply -analyze -silent -property_file /tmp/property_file.txt

echo "******************************************************************************"
echo "OMS Base Home - Apply." `date`
echo "******************************************************************************"
${ORACLE_HOME}/bin/emctl stop oms

omspatcher apply -silent -property_file /tmp/property_file.txt
${ORACLE_HOME}/OPatch/opatch lspatches
${ORACLE_HOME}/bin/emctl status oms -details

echo "******************************************************************************"
echo "Update AgentPatcher." `date`
echo "******************************************************************************"
export ORACLE_HOME=/u01/app/oracle/agent/agent_13.5.0.0.0
export PATH=$ORACLE_HOME/AgentPatcher:$PATH

cd $ORACLE_HOME
mv AgentPatcher AgentPatcher-old
unzip -oq /vagrant/software/p33355570_135000_Generic.zip
cd AgentPatcher
./agentpatcher version

echo "******************************************************************************"
echo "Agent Base Home - Analyze." `date`
echo "******************************************************************************"
cd /u01/software
unzip -oq p36335371_135000_Generic.zip
cd /u01/software/36335371
agentpatcher apply -analyze

echo "******************************************************************************"
echo "Agent Base Home - Apply." `date`
echo "******************************************************************************"
$ORACLE_HOME/bin/emctl stop agent
cd /u01/software/36335371
agentpatcher apply
$ORACLE_HOME/bin/emctl status agent
