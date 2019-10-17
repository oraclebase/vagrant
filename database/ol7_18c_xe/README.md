# Oracle 18c Express Edition (XE) on Oracle Linux 7

A simple Vagrant build for Oracle 18c Express Edition (XE) on Oracle Linux 7 using the XE RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 18c XE](https://www.oracle.com/database/technologies/appdev/xe.html)

Place the Oracle Express Edition (XE) RPM software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- scripts
|   +--- install_os_packages.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- oracle-database-xe-18c-1.0-1.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```