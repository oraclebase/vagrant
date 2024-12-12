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
dnf install -y make

# OL7 Packages
#dnf install -y libgcc.i686
#dnf install -y libstdc++.i686
#dnf install -y compat-libcap1
#dnf install -y compat-libstdc++-33
#dnf install -y compat-libstdc++-33.i686
#dnf install -y dejavu-serif-fonts
#dnf install -y ksh
#dnf install -y numactl
#dnf install -y numactl-devel

#dnf -y groupinstall "Server with GUI"
#systemctl set-default graphical.target

#dnf -y update
