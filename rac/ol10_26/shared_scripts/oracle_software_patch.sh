. /vagrant_config/install.env

# This patch script should only be used for a clean installation.
# It doesn't patch existing databases.
echo "******************************************************************************"
echo "Patch Oracle Grid Infrastructure Software." `date`
echo "HOSTNAME=$HOSTNAME"
echo "ORACLE_HOME=$1"
echo "******************************************************************************"
 
# Adjust to suit your patch level.
export ORACLE_HOME=${1}
export PATH=${ORACLE_HOME}/bin:$PATH
export PATH=${PATH}:${ORACLE_HOME}/OPatch

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"

cd ${SOFTWARE_DIR}
if [ ! -d ${PATCH_PATH2} ]; then
  unzip -oq /vagrant_software/${PATCH_FILE}
fi
chown -R oracle:oinstall ${PATCH_TOP}

opatchauto apply ${PATCH_PATH2} -oh ${ORACLE_HOME} --nonrolling
