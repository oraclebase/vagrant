# Oracle 21c (RPM) on Oracle Linux 8

A simple Vagrant build for Oracle Database 21c on Oracle Linux 8 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 21c](https://www.oracle.com/database/technologies/oracle21c-linux-downloads.html)

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
|   +--- oracle-database-ee-21c-1.0-1.ol8.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```