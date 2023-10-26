. /vagrant/config/install.env

# This patch script should only be used for a clean installation.
# It doesn't patch existing databases.
echo "******************************************************************************"
echo "Patch Oracle Software." `date`
echo "******************************************************************************"
 
export PATH=${ORACLE_HOME}/OPatch:${PATH}

echo "******************************************************************************"
echo "Patching preparation was done during software installation." `date`
echo "******************************************************************************"

#cd ${ORACLE_HOME}
#unzip -oq /vagrant/software/${OPATCH_FILE}
#
#echo "******************************************************************************"
#echo "Unzip software." `date`
#echo "******************************************************************************"
#
#cd ${SOFTWARE_DIR}
#unzip -oq /vagrant/software/${PATCH_FILE}

echo "******************************************************************************"
echo "Apply patches." `date`
echo "******************************************************************************"

# Applied during installation.
#cd ${PATCH_PATH1}
#opatch prereq CheckConflictAgainstOHWithDetail -ph ./
#opatch apply -silent

cd ${PATCH_PATH2}
opatch prereq CheckConflictAgainstOHWithDetail -ph ./
opatch apply -silent
