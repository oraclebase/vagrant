# Oracle 12.1 on Oracle Linux 8

A simple Vagrant build for Oracle Database 12.1 on Oracle Linux 8.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html)
* [Oracle REST Data Services (ORDS)](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/)
* [Oracle SQLcl](https://www.oracle.com/tools/downloads/sqlcl-downloads.html)
* [Oracle Application Express (APEX)](https://www.oracle.com/tools/downloads/apex-downloads.html)
* [OpenJDK 11](https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=hotspot#x64_linux)
* [Tomcat 9](https://tomcat.apache.org/download-90.cgi)

Place the Oracle database software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- config
|   +--- install.env
|   +--- vagrant.yml
+--- README.md
+--- scripts
|   +--- dbora.service
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- oracle_service_setup.sh
|   +--- oracle_software_installation.sh
|   +--- oracle_user_environment_setup.sh
|   +--- ords_software_installation.sh
|   +--- prepare_disks.sh
|   +--- root_setup.sh
|   +--- server.xml
|   +--- setup.sh
+--- software
|   +--- apache-tomcat-9.0.45.tar.gz
|   +--- apex_21.1_en.zip
|   +--- linuxamd64_12102_database_1of2.zip
|   +--- linuxamd64_12102_database_2of2.zip
|   +--- OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
|   +--- ords-21.1.1.116.2032.zip
|   +--- put_software_here.txt
|   +--- sqlcl-21.1.0.104.1544.zip
+--- Vagrantfile
$
```