# Oracle Enterprise Manager Cloud Control 13.3.

A simple Vagrant build of Enterprise Manager Cloud Control 13.3 on Oracle Database 19c.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 19c](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html)
* [Enterprise Manager Cloud Control 13.3](http://www.oracle.com/technetwork/oem/enterprise-manager/downloads/index.html)

Place the Oracle database and Cloud Control software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- scripts
|   +--- em_config.sh
|   +--- em_install.sh
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- oracle_software_installation.sh
|   +--- oracle_user_environment_setup.sh
|   +--- prepare_u01_disk.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- em13300_linux64-2.zip
|   +--- em13300_linux64-3.zip
|   +--- em13300_linux64-4.zip
|   +--- em13300_linux64-5.zip
|   +--- em13300_linux64-6.zip
|   +--- em13300_linux64.bin
|   +--- LINUX.X64_193000_db_home.zip
|   +--- put_software_here.txt
+--- Vagrantfile
$
```