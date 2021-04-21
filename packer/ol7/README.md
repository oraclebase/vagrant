# Packer Oracle Linux 7

Packer config for this box.

* [https://app.vagrantup.com/oraclebase/boxes/oracle-7](https://app.vagrantup.com/oraclebase/boxes/oracle-7)

This box tracks the latest Oracle Linux 7 spin with UEK.

Get the Packer software.

* [https://www.packer.io/downloads](https://www.packer.io/downloads)

To build the Virtualbox box add the Packer software to your path, switch to the root of the Packer build directory and run the Packer command. Amend your paths as needed.

```
set PATH=%USERPROFILE%\u01\software\hashicorp\packer_1.7.2_windows_amd64;%PATH%
cd \git\oraclebase\vagrant\packer\ol7

packer build -only virtualbox-iso ol7.json
```

This will create a box called "ol7-x86_64-virtualbox.box" in the "build" directory.

You can then upload the resulting box to Vagrant Cloud, or just use it locally by adding it to you local box list.

```
vagrant box remove oraclebase/oracle-7
vagrant box add build/ol7-x86_64-virtualbox.box --name oraclebase/oracle-7
```
