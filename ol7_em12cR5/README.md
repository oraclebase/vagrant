# Oracle Enterprise Manager Cloud Control 12cR5

A simple Vagrant build for Cloud Control 12cR5 on Oracle Database 12.1.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 12cR1](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html)
* [Enterprise Manager Cloud Control 12cR5](http://www.oracle.com/technetwork/oem/enterprise-manager/downloads/index.html)

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
|   +--- em12105_linux64_disk1.zip
|   +--- em12105_linux64_disk2.zip
|   +--- em12105_linux64_disk2.zip
|   +--- linuxamd64_12102_database_1of2.zip
|   +--- linuxamd64_12102_database_1of2.zip
|   +--- put_software_here.txt
+--- Vagrantfile
$
```