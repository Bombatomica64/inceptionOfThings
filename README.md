# Inception of things

install vagrant, vagrant-env, virtualbox and create 2 small VMs using vagrantfile

sudo apt-get update && sudo apt-get install -y libvirt-daemon libvirt-clients qemu-kvm
sudo systemctl start libvirtd && sudo systemctl enable libvirtd
vagrant plugin install vagrant-libvirt
