# Oracle 11.2 on Oracle Linux 7

A simple Vagrant build for Oracle Database 11.2 on Oracle Linux 7.

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
|   +--- apache-tomcat-9.0.16.tar.gz
|   +--- apex_18.2_en.zip
|   +--- linux.x64_11gR2_database_1of2.zip
|   +--- linux.x64_11gR2_database_2of2.zip
|   +--- openjdk-11.0.2_linux-x64_bin.tar.gz
|   +--- ords-18.4.0.354.1002.zip
|   +--- put_software_here.txt
|   +--- sqlcl-18.4.0.007.1818.zip
+--- Vagrantfile
$
```