# Packer Rocky Linux 8

This box tracks the latest Rocky Linux 8 spin.

Get the Packer software.

* [https://www.packer.io/downloads](https://www.packer.io/downloads)

To build the Virtualbox box add the Packer software to your path, switch to the root of the Packer build directory and run the Packer command. Amend your paths as needed.

```
set PATH=%USERPROFILE%\u01\software\hashicorp\packer_1.8.7_windows_amd64;%PATH%
cd \git\oraclebase\vagrant\packer\rocky8

packer build -only virtualbox-iso rocky8.json
```

This will create a box called "rocky8-x86_64-virtualbox.box" in the "build" directory.

You can then upload the resulting box to Vagrant Cloud, or just use it locally by adding it to you local box list.

```
vagrant box remove oraclebase/rocky-8
vagrant box add build/rocky8-x86_64-virtualbox.box --name oraclebase/rocky-8
```
