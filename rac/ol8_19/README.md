# Vagrant 19c Real Application Clusters (RAC) Build on Oracle Linux 8

The Vagrant scripts here will allow you to build a 19c Real Application Clusters (RAC) system on Oracle Linux 8. by just starting the VMs in the correct order.

If you need a more detailed description of this build, check out Tim Hall's article here (based on Oracel Linux 7).

* [Oracle Database 19c RAC On Oracle Linux 7 Using VirtualBox and Vagrant](https://oracle-base.com/articles/19c/oracle-db-19c-rac-installation-on-oracle-linux-7-using-virtualbox)


## Required Software

I've completed RAC installations using this method on the following host operating systems.

* Windows 10

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a RAC installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Git client. Pick one that matches your OS.

You will also need to download the 19c grid and database software.

* [Grid : LINUX.X64_193000_grid_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)
* [Database : LINUX.X64_193000_db_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)

## Warning

This installation requires a lot of memory.

The smallest system I've completed this on had 16G RAM, with the VM memory settings as follows and nothing else running.

```
dns:
  mem_size: 1024

node1:
  mem_size: 7168

node2:
  mem_size: 6144
```

The more memory you can throw at this the better.

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/KoussHD/vagrant.git
```

Copy the Oracle software under the "..../software/" directory. From the "rac" subdirectory, the structure should look like this.

```
$ tree
.
+--- config
|   +--- install.env
|   +--- vagrant.yml
+--- dns
|   +--- scripts
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- node1
|   +--- scripts
|   |   +--- oracle_create_database.sh
|   |   +--- oracle_db_software_installation.sh
|   |   +--- oracle_grid_software_config.sh
|   |   +--- oracle_grid_software_installation.sh
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- node2
|   +--- scripts
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- README.md
+--- shared_scripts
|   +--- configure_chrony.sh
|   +--- configure_hostname.sh
|   +--- configure_hosts_base.sh
|   +--- configure_hosts_scan.sh
|   +--- configure_shared_disks.sh
|   +--- install_os_packages.sh
|   +--- prepare_u01_disk.sh
+--- software
|   +--- LINUX.X64_193000_db_home.zip
|   +--- LINUX.X64_193000_grid_home.zip
|   +--- put_software_here.txt

$ 
```

## Amend File Paths

The "config" directory contains a "install.env" and a "vagrant.yml" file. The combination of these two files contain all the config used for this build. You can alter the configuration of the build here, but remember to make sure the combination of the two stay consistent.

At minimum you will have to amend the following path variables in the "vagrant.yml" file, providing suitable paths for the shared disks.

```
  asm_disk_1: /u05/VirtualBox/shared/ol8_19_rac/asm_disk_1.vdi
  asm_disk_2: /u05/VirtualBox/shared/ol8_19_rac/asm_disk_2.vdi
  asm_disk_3: /u05/VirtualBox/shared/ol8_19_rac/asm_disk_3.vdi
  asm_disk_4: /u05/VirtualBox/shared/ol8_19_rac/asm_disk_4.vdi
```

For example, if you were working on a Windows PC, you might create a path called "D:\VM\RAC\rhel8_19_rac" and use the following settings.

```
  asm_disk_1: D:\VM\RAC\ol8_19_rac\asm_disk_1.vdi
  asm_disk_2: D:\VM\RAC\ol8_19_rac\asm_disk_2.vdi
  asm_disk_3: D:\VM\RAC\ol8_19_rac\asm_disk_3.vdi
  asm_disk_4: D:\VM\RAC\ol8_19_rac\asm_disk_4.vdi
```

If you don't alter them,in this build they will get written to "D:\VM\RAC\rhel8_19_rac".

## Build the RAC

The following commands will leave you with a functioning RAC installation.

Start the DNS server.

```
cd dns
vagrant up
```

Start the second node of the cluster. This must be running before you start the first node.

```
cd ../node2
vagrant up
```

Ignore the final "default: Host key verification failed." message at the end. That's fine.

Start the first node of the cluster. This will perform all of the installations operations. Depending on the spec of the host system, this could take a long time. On one of my servers it took about 3.5 hours to complete.

```
cd ../node1
vagrant up
```

## Turn Off RAC

The below is supposed to turn off the RAC cleanly but I usually stop the crs first.

```
cd ../node2
vagrant ssh 
crsctl stop crs (as root)
vagrant halt

cd ../node1
vagrant halt

cd dns
vagrant halt
```

## Remove Whole RAC

The following commands will destroy all VMs and the associated files, so you can run the process again.

```
cd ../node2
vagrant destroy -f

cd ../node1
vagrant destroy -f

cd dns
vagrant destroy -f
```

Check all the shared disks have been removed as expected. If they are left behind they will be reused, which will cause problems.
