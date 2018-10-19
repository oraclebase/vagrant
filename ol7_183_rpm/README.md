# Oracle 18.3 (RPM) on Oracle Linux 7

A simple Vagrant build for Oracle Database 18.3 on Oracle Linux 7 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 18c (18.3)](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle18c-linux-180000-5022980.html)

Place the Oracle database RPM software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- scripts
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- oracle-database-ee-18c-1.0-1.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```