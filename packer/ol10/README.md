# Packer Oracle Linux 10

Packer config for this box.

* [https://app.vagrantup.com/oraclebase/boxes/oracle-10](https://app.vagrantup.com/oraclebase/boxes/oracle-10)

This box tracks the latest Oracle Linux 10 spin with UEK.

Get the Packer software.

* [https://www.packer.io/downloads](https://www.packer.io/downloads)

To build the Virtualbox box add the Packer software to your path, switch to the root of the Packer build directory and run the Packer command. Amend your paths as needed.

```
set PATH=%USERPROFILE%\u01\software\hashicorp\packer_1.13.1_windows_amd64;%PATH%
cd \git\oraclebase\vagrant\packer\ol10

packer plugins install github.com/hashicorp/vagrant
packer plugins install github.com/hashicorp/virtualbox

packer build -only virtualbox-iso ol10.json
```

This will create a box called "ol10-x86_64-virtualbox.box" in the "build" directory.

You can then upload the resulting box to Vagrant Cloud, or just use it locally by adding it to you local box list.

```
vagrant box remove oraclebase/oracle-10
vagrant box add build/ol10-x86_64-virtualbox.box --name oraclebase/oracle-10
```
