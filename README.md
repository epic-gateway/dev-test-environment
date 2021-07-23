# Development Test Environment

This project provides scripts to install and use Vagrant to create representative Customer Environments.

To use the enviroment clone the repo

If vagrant is not installed use the setup_vagrant_host.sh script to install Vagrant with
libvirt support.  Note that is required additional bridge setup to provide the host network for the router VM.

Execute Vagrant up in the singlenode directory to create three VMs and a bridge ($user-epic0) that connects these three VMs together.  The VM have static IP addresses on $user-epic0

1. router VM. (192.168.254.1)  This is a prebuilt router with FRR running and a FRR configuraiton that will accept BGP peers based upon the defaults used in EPIC.  It is connected to the host network and routes/NAT between the host network and the VM network.  The host network provides an address via DHCP.
2. EPIC VM. (192.168.254.10)  This is a VM that is prepared for the installation of EPIC.  Installation of EPIC is not automated.  It is connected to the bridge $user-epic0 and the default route is configured via the router VM
3. mk8s VM. (192.168.10.100)  This VM has the same configuration as above.  In addition mk8s is installed in this VM and some based additional tools such as aliases and kubens are added.  The mk8s is ready for the installation of Purelb(Ego)




Multinode is not yet implmented


The VM are accessed from the host machine using vagrant ssh

Services that are exposed by epic are accessed via the host network on the router VM.  A static route to the network exposed (default 192.168.77.0/24) from your workstatic is required to access LB services. 