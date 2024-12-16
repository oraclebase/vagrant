echo "******************************************************************************"
echo "Prepare dnf with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dnf install -y oracle-database-preinstall-19c

dnf install -y binutils
dnf install -y gcc
dnf install -y gcc-c++
dnf install -y glibc
dnf install -y glibc-devel
dnf install -y glibc-devel.i686
dnf install -y libaio
dnf install -y libaio-devel
dnf install -y libgcc
dnf install -y libstdc++
dnf install -y libstdc++-devel
dnf install -y libnsl
dnf install -y sysstat
dnf install -y motif
dnf install -y motif-devel
dnf install -y redhat-lsb
dnf install -y redhat-lsb-core
dnf install -y openssl
dnf install -y openssh-server
dnf install -y make

#dnf -y update
