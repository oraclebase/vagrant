# Oracle 19c (RPM) on Oracle Linux 7

A simple Vagrant build for Oracle Database 19c on Oracle Linux 7 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 19c](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)

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
|   +--- oracle-database-ee-19c-1.0-1.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```