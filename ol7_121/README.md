# Oracle 12.1 on Oracle Linux 7

A simple Vagrant build for Oracle Database 12.1 on Oracle Linux 7.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html)
* [Oracle REST Data Services (ORDS)](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html)
* [Oracle SQLcl](https://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html)
* [Oracle Application Express (APEX)](https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html)
* [OpenJDK 12](http://jdk.java.net/12/)
* [Tomcat 9](https://tomcat.apache.org/download-90.cgi)

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
|   +--- prepare_u01_u02_disks.sh
|   +--- root_setup.sh
|   +--- server.xml
|   +--- setup.sh
+--- software
|   +--- apache-tomcat-9.0.21.tar.gz
|   +--- apex_19.1_en.zip
|   +--- linuxx64_12201_database.zip
|   +--- openjdk-12.0.1_linux-x64_bin.tar.gz
|   +--- ords-19.1.0.092.1545.zip
|   +--- put_software_here.txt
|   +--- sqlcl-19.1.0.094.1619.zip
+--- Vagrantfile
$
```