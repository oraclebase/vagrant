# Oracle Database 23ai Free (RPM) on Oracle Linux 8

A simple Vagrant build for Oracle Database 23ai Free on Oracle Linux 8 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 23ai Free](https://www.oracle.com/database/technologies/free-downloads.html)
* [Oracle REST Data Services (ORDS)](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/)
* [Oracle SQLcl](https://www.oracle.com/tools/downloads/sqlcl-downloads.html)
* [Oracle Application Express (APEX)](https://www.oracle.com/tools/downloads/apex-downloads.html)
* [GraalVM](https://www.graalvm.org/downloads/)
* [Tomcat 9](https://tomcat.apache.org/download-90.cgi)

Place the Oracle database RPM software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- config
|   +--- install.env
+--- README.md
+--- scripts
|   +--- apex_software_installation.sh
|   +--- dbora.service
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- oracle_service_setup.sh
|   +--- oracle_user_environment_setup.sh
|   +--- ords_software_installation.sh
|   +--- root_setup.sh
|   +--- server.xml
|   +--- setup.sh
|   +--- web.xml
+--- software
|   +--- apache-tomcat-9.0.104.tar.gz
|   +--- apex_24.2_en.zip
|   +--- graalvm-jdk-21_linux-x64_bin.tar.gz
|   +--- oracle-database-free-23ai-1.0-1.el8.x86_64.rpm
|   +--- ords-latest.zip
|   +--- put_software_here.txt
|   +--- sqlcl-latest.zip
+--- Vagrantfile
$
```

The database password is set in the "install.env" file. By default it is set to "SysPassword1".

With everything in place, you can initiate the build as follows.

```
cd C:\git\oraclebase\vagrant\database\ol8_23_free\
vagrant up
```


## Using-It

From the "oracle" user we can connect as follows.

```
export ORACLE_HOME=/opt/oracle/product/23ai/dbhomeFree
export PATH=$ORACLE_HOME/bin:$PATH

-- Root container
sqlplus sys/SysPassword1@//localhost:1521/free as sysdba

-- Pluggable database
sqlplus sys/SysPassword1@//localhost:1521/freepdb1 as sysdba
```

We can stop and start the service from the root user with the following commands.

```
/etc/init.d/oracle-free-23ai stop
/etc/init.d/oracle-free-23ai start
```