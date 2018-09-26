echo "******************************************************************************"
echo "Amend hosts file with SCAN IPs." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
# SCAN
${SCAN_IP_1}    ${FQ_SCAN_NAME}    ${SCAN_NAME}
${SCAN_IP_2}    ${FQ_SCAN_NAME}    ${SCAN_NAME}
${SCAN_IP_3}    ${FQ_SCAN_NAME}    ${SCAN_NAME}
EOF