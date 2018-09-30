# Oracle 12.2 on Oracle Linux 7

A simple Vagrant build for Oracle Database 12.2 on Oracle Linux 7.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Place the Oracle database software in the "software" directory before calling the `vagrant up` command.

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
|   +--- root_setup.sh
|   +--- server.xml
|   +--- setup.sh
+--- software
|   +--- apache-tomcat-9.0.12.tar.gz
|   +--- apex_18.2_en.zip
|   +--- linuxx64_12201_database.zip
|   +--- openjdk-11_linux-x64_bin.tar.gz
|   +--- ords-18.2.0.zip
|   +--- put_software_here.txt
|   +--- sqlcl-18.2.0.zip
+--- Vagrantfile
$
```