# Oracle 23c Free Developer-Release (RPM) on Oracle Linux 8

A simple Vagrant build for Oracle Database 23c Free Developer-Release on Oracle Linux 8 using the RPM installation.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 23c](https://www.oracle.com/database/technologies/free-downloads.html)

Place the Oracle database RPM software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
+--- README.md
+--- config
|   +--- install.env
+--- scripts
|   +--- install_os_packages.sh
|   +--- oracle_create_database.sh
|   +--- root_setup.sh
|   +--- setup.sh
+--- software
|   +--- oracle-database-free-23c-1.0-1.el8.x86_64.rpm
|   +--- put_software_here.txt
+--- Vagrantfile
$
```

The database password is set in the "install.env" file. By default it is set to "SysPassword1".

## Using-It

From the "oracle" user we can connect as follows.

```
export ORACLE_HOME=/opt/oracle/product/23c/dbhomeFree
export PATH=$ORACLE_HOME/bin:$PATH

-- Root container
sqlplus sys/SysPassword1@//localhost:1521/free as sysdba

-- Pluggable database
sqlplus sys/SysPassword1@//localhost:1521/freepdb1 as sysdba
```

We can stop and start the service from the root user with the following commands.

```
/etc/init.d/oracle-free-23c stop
/etc/init.d/oracle-free-23c start
```