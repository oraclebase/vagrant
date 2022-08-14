# Vagrant 21c Data Guard PDB Build

The Vagrant scripts here will allow you to build the prerequisites for a 21c Data Guard PDB system by just starting the VMs in the correct order. Once built, you will be able to continue with the final DG PDB configuration described in the link below.

If you need a more detailed description of this build, check out the article here.

* [DG PDB : Data Guard for PDBs in Oracle Database 21c (21.7 Onward)](https://oracle-base.com/articles/21c/dg-pdb-21c)

## Required Software

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a Data Guard installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Git client. Pick one that matches your OS.

You will also need to download the 21c database software, along with at least the 21.7 (July 2022) release update.

* [Database LINUX.X64_213000_db_home.zip](https://www.oracle.com/database/technologies/oracle21c-linux-downloads.html)
* [21c Release Updates](https://support.oracle.com)

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/oraclebase/vagrant.git
```

Copy the Oracle software under the "dataguard/software" directory. From the "dataguard" subdirectory, the structure should look like this.

```
tree
.
+--- config
|   +--- install.env
|   +--- vagrant.yml
+--- node1
|   +--- scripts
|   |   +--- oracle_create_database.sh
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- node2
|   +--- scripts
|   |   +--- oracle_create_database.sh
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- README.md
+--- shared_scripts
|   +--- configure_chrony.sh
|   +--- configure_hostname.sh
|   +--- configure_hosts_base.sh
|   +--- configure_shared_disks.sh
|   +--- install_os_packages.sh
|   +--- oracle_db_software_installation.sh
|   +--- prepare_u01_disk.sh
+--- software
|   +--- LINUX.X64_213000_db_home.zip
|   +--- p34160444_210000_Linux-x86-64.zip
|   +--- p6880880_210000_Linux-x86-64.zip
|   +--- put_software_here.tx
```

The patch files in the "software" directory are optional. By detault the patch script is commented out from the node-specific "root_setup.sh" scripts.

## Build the Data Guard System

The following commands will leave you with a functioning Data Guard installation.

Start the first node and wait for it to complete. This will create the primary database.

```
cd node1
vagrant up
```

Start the second node and wait for it to complete. This will create the standby database and configure the broker.

```
cd ../node2
vagrant up
```

## Turn Off System

Perform the following to turn off the system cleanly.

```
cd ../node2
vagrant halt

cd ../node1
vagrant halt
```

## Remove Whole System

The following commands will destroy all VMs and the associated files, so you can run the process again.

```
cd ../node2
vagrant destroy -f

cd ../node1
vagrant destroy -f
```
