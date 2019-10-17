# VirtualBox VM for AWX installed on Docker

A VirtualBox VM for playing around with an AWX Docker build.

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Using It

Clone or [Download](https://github.com/oraclebase/vagrant/archive/master.zip) the repository.

```
git clone https://github.com/oraclebase/vagrant.git
```

Navigate to the AWX build and issue the `vagrant up` command.

```
# Linux
cd /path/to/vagrant/awx
vagrant up

Rem Windows
cd \path\to\vagrant\awx
vagrant up
```

Once the build is complete you should be able to access AWX using one of the following URLs.

* [http://localhost:8080](http://localhost:8080)
* [https://localhost:8443](https://localhost:8443)

Log in using the following credentials, assuming you've not changed them.

* Username: admin
* Password: password
