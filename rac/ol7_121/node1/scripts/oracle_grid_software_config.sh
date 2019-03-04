. /vagrant_config/install.env

echo "******************************************************************************"
echo "Check cluster configuration." `date`
echo "******************************************************************************"
${GRID_HOME}/bin/crsctl stat res -t
