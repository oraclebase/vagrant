echo "******************************************************************************"    
echo "Install KMV and Kcli" `date`                                                
echo "******************************************************************************"    

yum install -y qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer 
/usr/libexec/qemu-kvm --version
systemctl enable --now libvirtd
systemctl status libvirtd |grep Active
echo
echo +++++ "Install Kcli" `date` +++++++ 
echo
curl https://raw.githubusercontent.com/karmab/kcli/master/install.sh | sh 

echo "******************************************************************************"
echo "Install terraform." `date`
echo "******************************************************************************"
curl -O https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
unzip terraform_0.12.24_linux_amd64.zip -d /usr/bin/
terraform -version 
cd /root/
terraform init
cd /root/.terraform.d
mkdir plugins
echo
echo " import terraform provider for CentOS 7 / Fedora "
echo
wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.2/terraform-provider-libvirt-0.6.2+git.1585292411.8cbe9ad0.Fedora_28.x86_64.tar.gz
tar xvf terraform-provider-libvirt-0.6.2+git.1585292411.8cbe9ad0.Fedora_28.x86_64.tar.gz
mv terraform-provider-libvirt /root/.terraform.d/plugins/
echo
echo " Using Terraform KVM Provider"
echo
mkdir -p /root/projects/terraform

echo "******************************************************************************"
echo "Install Packer." `date`
echo "******************************************************************************"
  curl -O https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip
  curl -O https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_SHA256SUMS
  curl -O https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_SHA256SUMS.sig
  gpg --recv-keys 51852D87348FFC4C
  gpg --verify packer_1.5.5_SHA256SUMS.sig packer_1.5.5_SHA256SUMS
  sha256sum -c packer_1.5.5_SHA256SUMS 2>/dev/null | grep OK
  echo " named the Packer binary packer.io to avoid confusion with another redhat builtin program also called packer "
  unzip packer*.zip ; rm -f packer*.zip
  chmod +x packer
  mv packer /usr/bin/packer.io
packer.io  -v
packer.io -autocomplete-install