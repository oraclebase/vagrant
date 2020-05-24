. /vagrant_config/install.env

# This patch script should only be used for a clean installation.
# It doesn't patch existing databases.
echo "******************************************************************************"
echo "Patch Oracle Grid Infrastructure Software." `date`
echo "HOSTNAME=$HOSTNAME"
echo "ORACLE_HOME=$1"
echo "HOME_TYPE=$2"
echo "******************************************************************************"
 
# Adjust to suit your patch level.
export SOFTWARE_DIR=/u01/software
export ORACLE_HOME=${1}
export HOME_TYPE=${2}
export PATH=${ORACLE_HOME}/bin:$PATH
export PATH=${PATH}:${ORACLE_HOME}/OPatch
export OPATCH_FILE="p6880880_190000_Linux-x86-64.zip"
export PATCH_FILE="p30783556_190000_Linux-x86-64.zip"
export PATCH_TOP=${SOFTWARE_DIR}/30783556
export PATCH_PATH1=${PATCH_TOP}/30899722
export PATCH_PATH2=${PATCH_TOP}/30805684

echo "******************************************************************************"
echo "Prepare opatch." `date`
echo "******************************************************************************"

cd ${ORACLE_HOME}
unzip -oq /vagrant_software/${OPATCH_FILE}
chown -R oracle:oinstall ${ORACLE_HOME}/OPatch

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"

cd ${SOFTWARE_DIR}
if [ ! -d ${PATCH_PATH1} ]; then
  unzip -oq /vagrant_software/${PATCH_FILE}
fi
chown -R oracle:oinstall ${PATCH_TOP}

echo "******************************************************************************"
echo "Apply patches." `date`
echo "******************************************************************************"

opatchauto apply ${PATCH_PATH1} -oh ${ORACLE_HOME} --nonrolling

if [ "$HOME_TYPE" == "db" ]; then
  opatchauto apply ${PATCH_PATH2} -oh ${ORACLE_HOME} --nonrolling
fi