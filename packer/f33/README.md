# Packer Fedora 33

Packer config for this box.

* [https://app.vagrantup.com/oraclebase/boxes/fedora-33](https://app.vagrantup.com/oraclebase/boxes/fedora-33)

This box is based on the initial Fedora 33 release.

Get the Packer software.

* [https://www.packer.io/downloads](https://www.packer.io/downloads)

To build the VirtualBox box add the Packer software to your path, switch to the root of the Packer build directory and run the Packer command. Amend your paths as needed.

```
set PATH=%USERPROFILE%\u01\software\hashicorp\packer_1.6.2_windows_amd64;%PATH%
cd \git\oraclebase\vagrant\packer\f33

packer build -only virtualbox-iso f33.json
```

This will create a box called "f33-x86_64-virtualbox.box" in the "build" directory.

You can then upload the resulting box to Vagrant Cloud, or just use it locally by adding it to you local box list.

```
vagrant box remove oraclebase/fedora-33
vagrant box add build/f33-x86_64-virtualbox.box --name oraclebase/fedora-33
```
