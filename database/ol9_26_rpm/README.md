# Oracle Database 26ai (RPM) on Oracle Linux 9

A simple Vagrant build for Oracle Database 26ai on Oracle Linux 9 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle AI Database 26ai](https://www.oracle.com/database/technologies/free-downloads.html)

Place the Oracle database RPM software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- config
|   +--- install.env
+--- README.md
+--- scripts
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- oracle_user_environment_setup.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- oracle-ai-database-free-26ai-23.26.0-1.el9.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```

The database password is set in the "install.env" file. By default it is set to "SysPassword1".

With everything in place, you can initiate the build as follows.

```
cd C:\git\oraclebase\vagrant\database\ol9_26_rpm\
vagrant up
```


## Using-It

From the "oracle" user we can connect as follows.

```
export ORACLE_HOME=/opt/oracle/product/26ai/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=ORCLCDB

-- Root container
sqlplus sys/SysPassword1@//localhost:1521/free as sysdba

-- Pluggable database
sqlplus sys/SysPassword1@//localhost:1521/freepdb1 as sysdba
```

We can stop and start the service from the root user with the following commands.

```
/etc/init.d/oracledb_ORCLCDB-26ai stop
/etc/init.d/oracledb_ORCLCDB-26ai start
```