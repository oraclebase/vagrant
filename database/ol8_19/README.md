# Oracle 19c on Oracle Linux 8

A simple Vagrant build for Oracle Database 19c on Oracle Linux 8.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)
* [Oracle REST Data Services (ORDS)](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/)
* [Oracle SQLcl](https://www.oracle.com/tools/downloads/sqlcl-downloads.html)
* [Oracle Application Express (APEX)](https://www.oracle.com/tools/downloads/apex-downloads.html)
* [OpenJDK 11](https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot)
* [Tomcat 9](https://tomcat.apache.org/download-90.cgi)

If you want to patch the installation, you will also need these downloads.

* [Patch 32900021: COMBO OF OJVM RU COMPONENT 19.12.0.0.210720 + DB RU 19.12.0.0.210720](https://support.oracle.com)
* [Patch 6880880: OPatch 19.x](https://updates.oracle.com/download/6880880.html)

Place the software in the "software" directory before calling the `vagrant up` command.

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
|   +--- apache-tomcat-9.0.74.tar.gz
|   +--- apex_23.1_en.zip
|   +--- LINUX.X64_193000_db_home.zip
|   +--- OpenJDK11U-jdk_x64_linux_hotspot_11.0.19_7.tar.gz
|   +--- ords-latest.zip
|   +--- p35058163_190000_Linux-x86-64.zip
|   +--- p6880880_190000_Linux-x86-64.zip
|   +--- put_software_here.txt
|   +--- sqlcl-latest.zip
+--- Vagrantfile
$
```

If you want to include the patches, edit the PATCH_DB parameter in the "install.env" file.

With everything in place, you can initiate the build as follows.

```
cd C:\git\oraclebase\vagrant\database\ol8_19\
vagrant up
```
