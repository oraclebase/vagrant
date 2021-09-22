echo "******************************************************************************"
echo "Create default database." `date`
echo "******************************************************************************"
/etc/init.d/oracle-xe-21c configure <<EOF
SysPassword1
SysPassword1
EOF
