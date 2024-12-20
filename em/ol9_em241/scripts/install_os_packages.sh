echo "******************************************************************************"
echo "Prepare dnf with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y oracle-database-preinstall-19c

dnf install -y make
dnf install -y binutils
dnf install -y gcc
dnf install -y libaio
dnf install -y libstdc++
dnf install -y sysstat
dnf install -y glibc-devel
dnf install -y glibc-common
dnf install -y libXtst
dnf install -y libnsl

#dnf -y update
