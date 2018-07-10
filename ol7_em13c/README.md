# Oracle Enterprise Manager Cloud Control 13.3.

A simple Vagrant build for Oracle Database 12.2 on Oracle Linux 7 in preparation for a manual Enterprise Manager Cloud Control 13.3 installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 12.2](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index-092322.html)
* [Enterprise Manager Cloud Control 13.3](http://www.oracle.com/technetwork/oem/enterprise-manager/downloads/index.html)

Place the Oracle database and Cloud Control software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- scripts
|   +--- oracle_create_database.sh
|   +--- oracle_software_installation.sh
|   +--- oracle_user_environment_setup.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- em13300_linux64-2.zip
|   +--- em13300_linux64-3.zip
|   +--- em13300_linux64-4.zip
|   +--- em13300_linux64-5.zip
|   +--- em13300_linux64-6.zip
|   +--- em13300_linux64.bin
|   +--- linuxx64_12201_database.zip
|   +--- put_software_here.txt
+--- Vagrantfile
$
```