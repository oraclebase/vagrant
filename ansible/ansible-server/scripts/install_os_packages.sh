echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Base installation.
dnf install -y oracle-epel-release-el8
dnf install -y ansible

# Packages for demos.
dnf install -y git
