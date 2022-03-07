. /vagrant/config/install.env

# This patch script should only be used for a clean installation.
# It doesn't patch existing databases.
echo "******************************************************************************"
echo "Patch Oracle Software." `date`
echo "******************************************************************************"

export PATH=${ORACLE_HOME}/OPatch:${PATH}
 
echo "******************************************************************************"
echo "Prepare opatch." `date`
echo "******************************************************************************"

cd ${ORACLE_HOME}
unzip -oq /vagrant_software/${OPATCH_FILE}

echo "******************************************************************************"
echo "Unzip software." `date`
echo "******************************************************************************"

mkdir -p ${PATCH_TOP}
cp /vagrant_software/${PATCH_FILE} ${PATCH_TOP}
cd ${PATCH_TOP}
unzip -oq ${PATCH_FILE}

echo "******************************************************************************"
echo "Apply patches." `date`
echo "******************************************************************************"

cd ${PATCH_PATH1}
opatch prereq CheckConflictAgainstOHWithDetail -ph ./
opatch apply -silent

#cd ${PATCH_PATH2}
#opatch prereq CheckConflictAgainstOHWithDetail -ph ./
#opatch apply -silent