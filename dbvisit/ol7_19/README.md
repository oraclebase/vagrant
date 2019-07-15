# Vagrant Dbvisit Standby 9 on Oracle Linux 7 with Oracle Database 19c

The Vagrant scripts here will allow you to build a Dbvisit Standby 9 configuration on Oracle Linux 7 with Oracle Database 19c by just starting the VMs in the correct order.

If you need a more detailed description of this build, check out the article here.

* [Dbvisit Standby 9 Installation on Oracle Linux 7](https://oracle-base.com/articles/misc/dbvisit-standby-9)

## Required Software

Download and install the following software. If you can't figure out this step, you probably shouldn't be considering a RAC installation.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

You will also need to download the 19c database software and the Dbvisit Standby 9 software.

* [Database LINUX.X64_193000_db_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)
* [Dbvisit Standby 9](https://dbvisit.com/)

## Clone Repository

Pick an area on your file system to act as the base for this git repository and issue the following command. If you are working on Windows, remember to check your Git settings for line terminators. If the bash scripts are converted to Windows terminators you will have problems.

```
git clone https://github.com/oraclebase/vagrant.git
```

Copy the Oracle software under the "dbvisit/ol7_19/software" directory. From the "dbvisit/ol7_19" subdirectory, the structure should look like this.

```
tree
.
+--- config
|   +--- install.env
|   +--- vagrant.yml
+--- console
|   +--- scripts
|   |   +--- configure_dbvisit.sh
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- node1
|   +--- scripts
|   |   +--- configure_dbvisit.sh
|   |   +--- oracle_create_database.sh
|   |   +--- oracle_user_environment_setup.sh
|   |   +--- root_setup.sh
|   |   +--- setup.sh
|   +--- Vagrantfile
+--- node2
|   +--- scripts
|   |   +--- configure_dbvisit.sh
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
|   +--- install_os_packages.sh
|   +--- oracle_db_software_installation.sh
|   +--- prepare_u01_disk.sh
+--- software
|   +--- dbvisit-standby9.0.02-el7.zip
|   +--- LINUX.X64_193000_db_home.zip
|   +--- put_software_here.txt
```

## Build the Dbvisit Standby 9 System

The following commands will leave you with a functioning Dbvisit Standby 9 installation.

Start the first node and wait for it to complete. This will create the primary database.

```
cd node1
vagrant up
```

Start the second node and wait for it to complete. This will create the server to hold the standby database.

```
cd ../node2
vagrant up
```

Start the console node and wait for it to complete. This will create the Dbvisit Standby Console.

```
cd ../console
vagrant up
```

Note. If you are using serveral console windows, you can actually run them all at the same time, but wait for them all to complete before attempting to use the system.

## Turn Off System

Perform the following to turn off the system cleanly.

```
cd ../console
vagrant halt

cd ../node2
vagrant halt

cd ../node1
vagrant halt
```

## Remove Whole System

The following commands will destroy all VMs and the associated files, so you can run the process again.

```
cd ../console
vagrant destroy -f

cd ../node2
vagrant destroy -f

cd ../node1
vagrant destroy -f
```
