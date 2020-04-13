apt-get install vim git virt-install qemu-kvm libvirt-bin bridge-utils -y

brctl addbr brsw1
brctl addbr brsw2

sudo virt-install \
--name vyos1 \
--virt-type kvm \
--os-type linux \
--os-variant virtio26 \
--ram 2048 \
--vcpus 2 \
--hvm \
--network network:default,model=virtio \
--network bridge=brsw1,model=virtio \
--network bridge=brsw2,model=virtio \
--graphics none \
--autostart \
--cdrom /var/lib/libvirt/boot/vyos-1.1.8-amd64.iso \
--disk path=/var/lib/libvirt/images/vyos1.qcow2,format=qcow2,bus=virtio,size=2

# vyos/vyos and install image

sudo virt-install \
--name vyos2 \
--virt-type kvm \
--os-type linux \
--os-variant virtio26 \
--ram 2048 \
--vcpus 2 \
--hvm \
--network network:default,model=virtio \
--network bridge=brsw1,model=virtio \
--network bridge=brsw2,model=virtio \
--graphics none \
--autostart \
--cdrom /var/lib/libvirt/boot/vyos-1.1.8-amd64.iso \
--disk path=/var/lib/libvirt/images/vyos2.qcow2,format=qcow2,bus=virtio,size=2

# vyos/vyos and install image
