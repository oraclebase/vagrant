# Packer Fedora 38

Packer config for this box.

* [https://app.vagrantup.com/oraclebase/boxes/fedora-38](https://app.vagrantup.com/oraclebase/boxes/fedora-37)

This box is based on the initial Fedora 38 release.

Get the Packer software.

* [https://www.packer.io/downloads](https://www.packer.io/downloads)

To build the VirtualBox box add the Packer software to your path, switch to the root of the Packer build directory and run the Packer command. Amend your paths as needed.

```
set PATH=%USERPROFILE%\u01\software\hashicorp\packer_1.8.6_windows_amd64;%PATH%
cd \git\oraclebase\vagrant\packer\f38

packer build -only virtualbox-iso f38.json
```

This will create a box called "f38-x86_64-virtualbox.box" in the "build" directory.

You can then upload the resulting box to Vagrant Cloud, or just use it locally by adding it to you local box list.

```
vagrant box remove oraclebase/fedora-38
vagrant box add build/f38-x86_64-virtualbox.box --name oraclebase/fedora-38
```
