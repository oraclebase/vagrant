# Oracle 19c on Red Hat Linux 8 -Light

A simple Vagrant build for Oracle Database 19c on Red hat linux 8. This version doesn't install the secondary softwares (Apex,ords ..) initially included in Tim Halls Database Build (commented in the scripts). 

Note: the vagrant base box of RHEL8 (generic/rhel8)is generic and shipped without the prerequisite rpm packages for Oracle 19c.
All necessary OS packages are added during the vagrant run since I included the online rhel8 package repository as local repo in the scripts.     

Enjoy

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)

Place the software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- scripts
|   +--- dbora.service
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- oracle_service_setup.sh
|   +--- oracle_software_installation.sh
|   +--- oracle_user_environment_setup.sh
|   +--- ords_software_installation.sh
|   +--- prepare_u01_u02_disks.sh
|   +--- root_setup.sh
|   +--- server.xml
|   +--- setup.sh
+--- software
|   +--- LINUX.X64_193000_db_home.zip
+--- Vagrantfile
$
```