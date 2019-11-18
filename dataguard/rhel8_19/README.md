# Vagrant 19c Data Guard Build on a prepackaged Red Hat Linux 8

Note: the vagrant base box of RHEL8 is shipped with all the prerequisite rpm packages for Oracle 19c. tested with few Tim Hall builds so far

The Vagrant scripts here will allow you to build a 19c Data Guard system on Red Hat linux 8. by just starting the VMs in the correct order.


This configuration is slightly modified comparing to Tim hall's original build but it merely resides in the below environment variables values.

```
export DOMAIN_NAME=evilcorp.com

export NODE1_HOSTNAME=montreal
export NODE2_HOSTNAME=toronto
export NODE1_PUBLIC_IP=192.168.78.54
export NODE2_PUBLIC_IP=192.168.78.55
export ORACLE_SID=montreal
export NODE1_DB_UNIQUE_NAME=montreal
export NODE2_DB_UNIQUE_NAME=toronto
export ROOT_PASSWORD=racattack
export ORACLE_PASSWORD=oracle
export SYS_PASSWORD="racattack"
export PDB_PASSWORD="PdbPassword1!"

```

If you need a more detailed description of the original build, check out the article here.

* [Data Guard Physical Standby Setup Using the Data Guard Broker in Oracle Database 19c](https://oracle-base.com/articles/19c/data-guard-setup-using-broker-19c)

## Required Software

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a Data Guard installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Git client. Pick one that matches your OS.

You will also need to download the 19c database software.

* [Database LINUX.X64_193000_db_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/KoussHD/vagrant.git
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
|   +--- LINUX.X64_193000_db_home.zip
|   +--- put_software_here.tx
```

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

Perform the following to turn off the system cleanly. (stop_all script will set state to apply-off or transport-off according to the role of the node's DB)
 
 On Node 1
```
oracle@# /home/oracle/scripts/stop_all.sh 
cd ../node2
vagrant halt
```
On Node 2
```
oracle@# /home/oracle/scripts/stop_all.sh 
cd ../node1
vagrant halt
```

## Restart the System after first install and shutdown 
  Perform the following to turn on the system cleanly. (start_all will run a startup if local DB role is a Primary or startup mount if the local DB role is Standby)
  
   ```
   cd node1
   vagrant up
   oracle@# /home/oracle/scripts/start_all.sh
   ```
   
   ```
   cd node2
   vagrant up
   oracle@# /home/oracle/scripts/start_all.sh
  ```
  
  

## Remove Whole System

The following commands will destroy all VMs and the associated files, so you can run the process again.

```
cd ../node2
vagrant destroy -f

cd ../node1
vagrant destroy -f
```