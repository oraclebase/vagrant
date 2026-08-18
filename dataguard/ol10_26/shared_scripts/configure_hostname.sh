echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostname ${ORACLE_HOSTNAME}
cat > /etc/hostname <<EOF
${ORACLE_HOSTNAME}
EOF
