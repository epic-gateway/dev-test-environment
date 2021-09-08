# Development Test Environment

This project provides scripts to install and use Vagrant to create representative Customer Environments.


## If your running it on a host at Hurricane

 They are already setup.  Just clone into your home directory on the host you want to use and start the version you want. 


## To use in your Environment

You should be able to run the single node version, the multinode version is 7 host, take a look at the resources required in the vagrantfile

Before cloning the repo a bridge connecting the router to your network is required.  The netplan configuration will look like this.

```
network:
    ethernets:
        enp8s0f0:
            dhcp4: false
            dhcp6: false
            accept-ra: false
    bridges:
      brext0:
        interfaces:
        - enp8s0f0
    
    version: 2

```

Clone the repo and run setup_vagrant_host.sh as root

You will also need a copy of the frrouter box, you will need to get this from Adam, its a big file


```
$ vagrant box add router2 --name frrouter
```


## How to use.


Execute Vagrant up in the singlenode directory to create three VMs and a bridge ($user-epic0) that connects these three VMs together.  The VM have static IP addresses on $user-epic0

1. router VM. (192.168.254.1)  This is a prebuilt router with FRR running and a FRR configuraiton that will accept BGP peers based upon the defaults used in EPIC.  It is connected to the host network and routes/NAT between the host network and the VM network.  The host network provides an address via DHCP.
2. EPIC VM. (192.168.254.10)  This is a VM that is prepared for the installation of EPIC.  Installation of EPIC is not automated.  It is connected to the bridge $user-epic0 and the default route is configured via the router VM
3. mk8s VM. (192.168.10.100)  This VM has the same configuration as above.  In addition mk8s is installed in this VM and some based additional tools such as aliases and kubens are added.  The mk8s is ready for the installation of Purelb(Ego)




Multinode
This is basically the same as above but creates 3 nodes for epic and 3 nodes for mk8s

epic1-192.168.254.11
epic2-192.168.254.12
epic3-192.168.254.13

mk8s1-192.168.254.101
mk8s2-192.168.254.102
mk8s3-192.168.254.103

Note:  mk8s setup installs microk8s but does not combine them into a cluster.  Use the standard microk8s commands if thats what you want.


The VM are accessed from the host machine using vagrant ssh

Services that are exposed by epic are accessed via the host network on the router VM.  A static route to the network exposed (default 192.168.77.0/24) from your workstation to the vagrant router box is required to access LB services. 