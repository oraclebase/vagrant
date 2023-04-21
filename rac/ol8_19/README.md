# Vagrant 19c Real Application Clusters (RAC) Build

The Vagrant scripts here will allow you to build a 19c Real Application Clusters (RAC) system by just starting the VMs in the correct order.

If you need a more detailed description of this build, check out the article here.

* [Oracle Database 19c RAC On Oracle Linux 8 Using VirtualBox and Vagrant](https://oracle-base.com/articles/19c/oracle-db-19c-rac-installation-on-oracle-linux-8-using-virtualbox)

## Required Software

I've completed RAC installations using this method on the following host operating systems.

* Windows 10
* Oracle Linux 7
* macOS Mojave

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a RAC installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Git client. Pick one that matches your OS.

You will also need to download the 19c grid and database software, along with the latest combo patch for grid. This means you must have an Oracle Support account to complete this installation.

* [Grid : LINUX.X64_193000_grid_home.zip](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html)
* [Database : LINUX.X64_193000_db_home.zip](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html)
* [Patch 35058172 : COMBO OF OJVM RU COMPONENT 19.19.0.0.210119 + GI RU 19.19.0.0.210119](https://support.oracle.com)
* [Patch 6880880: OPatch 19.x](https://updates.oracle.com/download/6880880.html)

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

The more memory you can throw at this the better. I regularly use 21G RAM just for the VMs, not including the memory for the host system.

```
dns:
  mem_size: 1024

node1:
  mem_size: 10240

node2:
  mem_size: 10240
```

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/oraclebase/vagrant.git
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
|   +--- configure_hosts_base.sh
|   +--- configure_hosts_scan.sh
|   +--- configure_shared_disks.sh
|   +--- install_os_packages.sh
|   +--- oracle_software_patch.sh
|   +--- prepare_u01_disk.sh
+--- software
|   +--- LINUX.X64_193000_db_home.zip
|   +--- LINUX.X64_193000_grid_home.zip
|   +--- p6880880_190000_Linux-x86-64.zip
|   +--- p35058172_190000_Linux-x86-64.zip
|   +--- put_software_here.txt

$ 
```

## Amend File Paths

The "config" directory contains a "install.env" and a "vagrant.yml" file. The combination of these two files contain all the config used for this build. You can alter the configuration of the build here, but remember to make sure the combination of the two stay consistent.

At minimum you will have to amend the following paths in the "vagrant.yml" file, providing suitable paths for the shared disks.

```
  asm_crs_disk_1: /u05/VirtualBox/shared/ol8_19_rac/asm_crs_disk_1.vdi
  asm_crs_disk_2: /u05/VirtualBox/shared/ol8_19_rac/asm_crs_disk_2.vdi
  asm_crs_disk_3: /u05/VirtualBox/shared/ol8_19_rac/asm_crs_disk_3.vdi
  asm_crs_disk_size: 2
  asm_data_disk_1: /u05/VirtualBox/shared/ol8_19_rac/asm_data_disk_1.vdi
  asm_data_disk_size: 40
  asm_reco_disk_1: /u05/VirtualBox/shared/ol8_19_rac/asm_reco_disk_1.vdi
  asm_reco_disk_size: 20
```

For example, if you were working on a Windows PC, you might create a path called "C:\VirtualBox\shared\ol8_19_rac" and use the following settings.

```
  asm_crs_disk_1: C:\VirtualBox\shared\ol8_19_rac\asm_crs_disk_1.vdi
  asm_crs_disk_2: C:\VirtualBox\shared\ol8_19_rac\asm_crs_disk_2.vdi
  asm_crs_disk_3: C:\VirtualBox\shared\ol8_19_rac\asm_crs_disk_3.vdi
  asm_crs_disk_size: 2
  asm_data_disk_1: C:\VirtualBox\shared\ol8_19_rac\asm_data_disk_1.vdi
  asm_data_disk_size: 40
  asm_reco_disk_1: C:\VirtualBox\shared\ol8_19_rac\asm_reco_disk_1.vdi
  asm_reco_disk_size: 20
```

If you don't alter them, they will get written to "C:\u05\VirtualBox\shared\ol8_19_rac".

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

Start the first node of the cluster. This will perform all of the installations operations. Depending on the spec of the host system, this could take a long time. On one of my servers it took about 3.5 hours to complete.

```
cd ../node1
vagrant up
```

## Turn Off RAC

Perform the following to turn off the RAC cleanly.

```
cd ../node2
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

## DHCP Server Issue

If the VirtualBox DHCP server is enabled, you may see something like this.

* DNS up and running.
* Node2 up and running.
* Node1 grid configuration fails with the following error.

```
default: Do grid software-only installation. Wed Nov 18 23:32:46 UTC 2020
default: ******************************************************************************
default: Launching Oracle Grid Infrastructure Setup Wizard...
default: [FATAL] [INS-40718] Single Client Access Name (SCAN):ol7-19-scan could not be resolved.
default:    CAUSE: The name you provided as the SCAN could not be resolved using TCP/IP host name lookup.
default:    ACTION: Provide name to use for the SCAN for which the domain can be resolved.
```

I have seen this a few times on a Windows laptop (my main workstation). I've not seen it on macOS or Linux. It is almost like Node1 can't see the DNS, even though it is there, and Node2 can see it. I figure it must be some silly eccentricity of VirtualBox on Windows.

There are two workarounds for this.

Disable the VirtualBox DHCP server. Navigate to "File > Host Network Manager > DHCP Server (tab)". Uncheck the "Enable Server" checkbox and click the "Apply" button.

Alternatively, do the following during the startup process.

* Start up DNS.
* Start Node2.
* Start Node1.
* While Node1 is doing the OS prerequisites, stop and start the DNS node (vagrant halt, then vagrant up). That's not a rebuild. Just a restart. Clearly the DNS must be restarted before the installation takes place.

Something about the DNS restart allows Node1 to see the DNS.
