# Vagrant 18c Real Application Clusters (RAC) Build

The Vagrant scripts here will allow you to build a 18c Real Application Clusters (RAC) system by just starting the VMs in the correct order.

If you need a more detailed description of this build, check out the article here.

* [Oracle Database 18c RAC On Oracle Linux 7 Using VirtualBox and Vagrant](https://oracle-base.com/articles/18c/oracle-db-18c-rac-installation-on-oracle-linux-7-using-virtualbox)

## Required Software

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a RAC installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Git client. Pick one that matches your OS.

You will also need to download the 18c grid and database software.

* [LINUX.X64_180000_grid_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle18c-linux-180000-5022980.html)
* [LINUX.X64_180000_db_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle18c-linux-180000-5022980.html)

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/oraclebase/vagrant.git
```

Copy the Oracle software under the "..../node1/software/" directory. From the "rac" subdirectory, the structure should look like this.

```
$ tree
.
|-- config
|   |-- install.env
|   `-- vagrant.yml
|-- dns
|   |-- scripts
|   |   |-- root_setup.sh
|   |   `-- setup.sh
|   `-- Vagrantfile
|-- node1
|   |-- scripts
|   |   |-- oracle_create_database.sh
|   |   |-- oracle_db_software_installation.sh
|   |   |-- oracle_grid_software_config.sh
|   |   |-- oracle_grid_software_installation.sh
|   |   |-- oracle_user_environment_setup.sh
|   |   |-- root_setup.sh
|   |   `-- setup.sh
|   |-- software
|   |   |-- LINUX.X64_180000_db_home.zip
|   |   |-- LINUX.X64_180000_grid_home.zip
|   |   `-- put_software_here.txt
|   `-- Vagrantfile
|-- node2
|   |-- scripts
|   |   |-- oracle_user_environment_setup.sh
|   |   |-- root_setup.sh
|   |   `-- setup.sh
|   `-- Vagrantfile
|-- README.md
`-- shared_scripts
    |-- configure_chrony.sh
    |-- configure_hostname.sh
    |-- configure_hosts_base.sh
    |-- configure_hosts_scan.sh
    |-- configure_shared_disks.sh
    |-- db_env
    |-- grid_env
    |-- install_os_packages.sh
    `-- prepare_u01_disk.sh

$ 
```

## Amend File Paths

The "config" directory contains a "install.env" and a "vagrant.yml" file. The combination of these two files contain all the config used for this build. You can alter the configuration of the build here, but remember to make sure the combination of the two stay consistent.

At minimum you will have to amend the following paths in the "vagrant.yml" file, providing suitable paths for the shared disks.

```
  asm_disk_1: /u05/VirtualBox/shared/ol7_183_rac/asm_disk_1.vdi
  asm_disk_2: /u05/VirtualBox/shared/ol7_183_rac/asm_disk_2.vdi
  asm_disk_3: /u05/VirtualBox/shared/ol7_183_rac/asm_disk_3.vdi
  asm_disk_4: /u05/VirtualBox/shared/ol7_183_rac/asm_disk_4.vdi
```

For example, if you were working on a Windows PC, you might create a path called "C:\VirtualBox\shared\ol7_183_rac" and use the following settings.

```
  asm_disk_1: C:\VirtualBox\shared\ol7_183_rac\asm_disk_1.vdi
  asm_disk_2: C:\VirtualBox\shared\ol7_183_rac\asm_disk_2.vdi
  asm_disk_3: C:\VirtualBox\shared\ol7_183_rac\asm_disk_3.vdi
  asm_disk_4: C:\VirtualBox\shared\ol7_183_rac\asm_disk_4.vdi
```

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
