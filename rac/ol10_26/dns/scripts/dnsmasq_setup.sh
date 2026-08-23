echo "******************************************************************************"
echo "Install dnsmasq." `date`
echo "******************************************************************************"
dnf install -y dnsmasq
sed -i -e "s|\#interface=|interface=eth1|g" /etc/dnsmasq.conf
sed -i -e "s|interface=lo|\#interface=lo|g" /etc/dnsmasq.conf
systemctl enable dnsmasq
systemctl restart dnsmasq

SERVICE_FILE="/usr/lib/systemd/system/dnsmasq.service"

# Check if the service file exists
if [ -f "${SERVICE_FILE}" ]; then
  # Check if the [Service] section already exists
  if grep -q "\[Service\]" "${SERVICE_FILE}"; then
    # Add the Restart=on-failure directive to the [Service] section
    sed -i "/\[Service\]/a Restart=on-failure \nRestartSec=5s" "${SERVICE_FILE}"
  else
    # Create a new [Service] section with the Restart=on-failure directive
    echo "[Service]
Restart=on-failure
RestartSec=5s" >> "${SERVICE_FILE}"
  fi
else
  echo "Error: Service file not found"
  exit 1
fi

# Reload the systemd daemon to apply the changes
systemctl daemon-reload
systemctl restart dnsmasq
